import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/my_friends/my_friends_modal/my_friends_modal.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:pludin/classes/user_profile_new/user_profile_new.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../database/database_helper.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  //
  int segmentedControlValue = 0;
  //
  var strFriendLoader = '0';
  late DataBase handler;
  var strLoginUserId = '';
  var arrSearchFriend = [];
  //
  final friendApiCall = FriendModal();
  //
  @override
  void initState() {
    super.initState();

    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
  }

  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
        // if (kDebugMode) {
        //   print(value);
        //   print(value.length);
        // }
        if (value.isEmpty) {
          if (kDebugMode) {
            print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
          }
          // call firebase server
        } else {
          if (kDebugMode) {
            print('YES, LOCAL DB HAVE SOME DATA');
          }
          //

          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    //
                  },
                //
                // HIT WEBSERVICE TO SEARCH FRIEND
                friendApiCall
                    .friendsWB(
                      strLoginUserId.toString(),
                      '2',
                    )
                    .then((value) => {
                          setState(() {
                            arrSearchFriend = value;
                            strFriendLoader = '1';
                          })
                        }),
                //
              });
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Friends',
          Colors.white,
          18.0,
        ),
        // leading: IconButton(
        //   onPressed: () {
        //     if (kDebugMode) {
        //       print('object');
        //     }
        //     //
        //     // Navigator.pop(context);
        //     //
        //   },
        //   icon: const Icon(
        //     Icons.menu,
        //   ),
        // ),
        backgroundColor: navigationColor,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: CupertinoSegmentedControl<int>(
                  selectedColor: navigationColor,
                  borderColor: Colors.white,
                  children: const {
                    0: Text('Friends'),
                    1: Text('Requests'),
                    // 2: Text('Prefer not to say'),
                  },
                  onValueChanged: (int val) {
                    setState(() {
                      if (kDebugMode) {
                        print(val);
                      }
                      strFriendLoader = '0';
                      segmentedControlValue = val;
                    });
                    //
                    if (segmentedControlValue == 0) {
                      // HIT WEBSERVICE TO SEARCH FRIEND
                      friendApiCall
                          .friendsWB(
                            strLoginUserId.toString(),
                            '2',
                          )
                          .then((value) => {
                                setState(() {
                                  arrSearchFriend = value;
                                  strFriendLoader = '1';
                                })
                              });
                    } else {
                      friendApiCall
                          .friendsWB(
                            strLoginUserId.toString(),
                            '1',
                          )
                          .then((value) => {
                                setState(() {
                                  arrSearchFriend = value;
                                  strFriendLoader = '1';
                                })
                              });
                    }
                  },
                  groupValue: segmentedControlValue,
                ),
              ),
            ),
            //
            (strFriendLoader == '0')
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (arrSearchFriend.isEmpty)
                    ? Align(
                        alignment: Alignment.center,
                        child: textWithRegularStyle(
                          'No data found',
                          Colors.black,
                          14.0,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //
                            ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              // scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: arrSearchFriend.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: (strLoginUserId ==
                                          arrSearchFriend[index]['userId']
                                              .toString())
                                      ? (arrSearchFriend[index]['status']
                                                  .toString() ==
                                              '2')
                                          ? (arrSearchFriend[index][
                                                          'FirstSettingProfilePicture']
                                                      .toString() ==
                                                  '3')
                                              ? placeholderImageUI()
                                              : (arrSearchFriend[index]
                                                              ['FirstUserimage']
                                                          .toString() ==
                                                      '')
                                                  ? placeholderImageUI()
                                                  : realFirstUserImageUI(index)

                                          ///
                                          : (arrSearchFriend[index]['status']
                                                      .toString() ==
                                                  '1') // not a friend
                                              ? (arrSearchFriend[index][
                                                              'FirstSettingProfilePicture']
                                                          .toString() ==
                                                      '1') // everyone show image without being fridn
                                                  ? realFirstUserImageUI(index)
                                                  : placeholderImageUI()
                                              : Text('data 2')

                                      /*(arrSearchFriend[index]['FirstUserimage']
                                              .toString() ==
                                          '')
                                      ? placeholderImageUI()
                                      : realFirstUserImageUI(index)*/

                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      : (arrSearchFriend[index]
                                                      ['SecondUserimage']
                                                  .toString() ==
                                              '')
                                          ? placeholderImageUI()
                                          : realSecondImageUserUI(index),
                                  title: (strLoginUserId ==
                                          arrSearchFriend[index]['userId']
                                              .toString())
                                      ? textWithBoldStyle(
                                          //
                                          arrSearchFriend[index]
                                                  ['FirstfullName']
                                              .toString(),
                                          // '12',
                                          //
                                          Colors.black,
                                          16.0,
                                        )
                                      : textWithBoldStyle(
                                          //
                                          arrSearchFriend[index]
                                                  ['SecondfullName']
                                              .toString(),
                                          // '12',
                                          //
                                          Colors.black,
                                          16.0,
                                        ),
                                  subtitle: (strLoginUserId ==
                                          arrSearchFriend[index]['userId']
                                              .toString())
                                      ? textWithRegularStyle(
                                          //
                                          arrSearchFriend[index]['Firstemail']
                                              .toString(),
                                          // '12',
                                          Colors.blueGrey,
                                          14.0,
                                        )
                                      : textWithRegularStyle(
                                          //
                                          arrSearchFriend[index]['Secondemail']
                                              .toString(),
                                          // '12',
                                          Colors.blueGrey,
                                          14.0,
                                        ),
                                  trailing: InkWell(
                                    onTap: () {
                                      //
                                      (strLoginUserId ==
                                              arrSearchFriend[index]['userId']
                                                  .toString())
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfileNewScreen(
                                                  strUserId:
                                                      arrSearchFriend[index]
                                                              ['profileId']
                                                          .toString(),
                                                  strGetPostUserId:
                                                      arrSearchFriend[index]
                                                              ['profileId']
                                                          .toString(),
                                                ),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfileNewScreen(
                                                  strUserId:
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString(),
                                                  strGetPostUserId:
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString(),
                                                ),
                                              ),
                                            );

                                      /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfileScreen(
                                                  strUserId:
                                                      arrSearchFriend[index]
                                                              ['profileId']
                                                          .toString(),
                                                ),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfileScreen(
                                                  strUserId:
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString(),
                                                ),
                                              ),
                                            );*/
                                      //
                                    },
                                    child: (arrSearchFriend[index]['status']
                                                .toString() ==
                                            '1')
                                        ? (arrSearchFriend[index]['profileId']
                                                    .toString() ==
                                                strLoginUserId.toString())
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                width: 120,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: textWithBoldStyle(
                                                    'new request',
                                                    Colors.white,
                                                    14.0,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                width: 100,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: textWithBoldStyle(
                                                    'sent',
                                                    Colors.white,
                                                    16.0,
                                                  ),
                                                ),
                                              )
                                        : Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: 100,
                                            height: 48.0,
                                            decoration: BoxDecoration(
                                              color: navigationColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child: Center(
                                              child: textWithBoldStyle(
                                                'View',
                                                Colors.white,
                                                16.0,
                                              ),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            //
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  funcShowUI() {}

  Container realSecondImageUserUI(int index) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          30,
        ),
        child: Image.network(
          //
          arrSearchFriend[index]['SecondUserimage'].toString(),
          height: 60,
          width: 60,
          fit: BoxFit.cover,
          //
        ),
      ),
    );
  }

  Container realFirstUserImageUI(int index) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          30,
        ),
        child: Image.network(
          //
          arrSearchFriend[index]['FirstUserimage'].toString(),
          height: 60,
          width: 60,
          fit: BoxFit.cover,
          //
        ),
      ),
    );
  }

  Container placeholderImageUI() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
