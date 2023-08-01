import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:pludin/classes/controllers/custom_app_bar/custom_app_bar.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
import 'package:pludin/classes/controllers/search_friends/search_friend_modal/search_friend_modal.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:pludin/classes/user_profile_new/user_profile_new.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../database/database_helper.dart';
import '../my_friends/my_friends_modal/my_friends_modal.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  //
  var strSearchFriendloader = '';
  var strProfile = '2';
  //
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contGrindName;
  //
  late DataBase handler;
  final searchFriendApiCall = SearchFriendModal();
  //
  var strLoginUserId = '';
  var arrSearchFriend = [];
  //
  final friendApiCall = FriendModal();
  //
  @override
  void initState() {
    super.initState();
    contGrindName = TextEditingController();
    //
    handler = DataBase();
    //
    funcGetLocalDBdata();
  }

  @override
  void dispose() {
    contGrindName.dispose();

    super.dispose();
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
                    // print('dishant rajput 1.1 ====> $strLoginUserId'),
                    // print(widget.strUserId),
                    //
                  },
                //
                friendApiCall
                    .friendsWB(
                      strLoginUserId.toString(),
                      '1',
                    )
                    .then((value) => {
                          setState(() {
                            arrSearchFriend = value;
                            strProfile = '1';
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
        title: textWithBoldStyle(
          'Search Friend',
          Colors.white,
          18.0,
        ),
        backgroundColor: navigationColor,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: (strProfile == '1')
            ? friendRequestListWB()
            : searchFriendListUI(context),
      ),
    );
  }

  Column searchFriendListUI(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: 160,
          decoration: BoxDecoration(
            color: navigationColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0xffDDDDDD),
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0.1, 0.2),
              )
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(14.0),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: contGrindName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Friend...',
                ),
                onEditingComplete: () {
                  //do your stuff
                  if (kDebugMode) {
                    print('dismiss keybaord');
                  }

                  // dismiss keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  //
                  //
                  //
                  showLoadingUI(context, 'please wait...');
                  //
                  //
                  if (contGrindName.text == '') {
                    friendApiCall
                        .friendsWB(
                          strLoginUserId.toString(),
                          '1',
                        )
                        .then((value) => {
                              setState(() {
                                Navigator.pop(context);
                                arrSearchFriend = value;
                                strProfile = '1';
                              })
                            });
                  } else {
                    // HIT WEBSERVICE TO SEARCH FRIEND
                    searchFriendApiCall
                        .searchFriendsWB(
                          strLoginUserId.toString(),
                          contGrindName.text.toString(),
                        )
                        .then((value) => {
                              setState(() {
                                Navigator.pop(context);
                                arrSearchFriend = value;
                                print('dishant rajpuut 1.0');
                                print(arrSearchFriend.length);
                                strProfile = '2';
                              })
                            });
                  }

                  //
                },
                // validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter grind name';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        //
        ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          // scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: arrSearchFriend.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: (arrSearchFriend[index]['Userimage'].toString() == '')
                  ? Container(
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
                    )
                  : Container(
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
                          arrSearchFriend[index]['Userimage'].toString(),
                          //
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          //
                        ),
                      ),
                    ),
              title: textWithBoldStyle(
                //
                arrSearchFriend[index]['fullName'].toString(),
                // '12',
                //
                Colors.black,
                16.0,
              ),
              /*subtitle: textWithRegularStyle(
                '325 friends circle',
                Colors.blueGrey,
                14.0,
              ),*/
              trailing: InkWell(
                onTap: () {
                  //
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MyProfileScreen(
                  //       strUserId: arrSearchFriend[index]['userId'].toString(),
                  //     ),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileNewScreen(
                        strUserId: arrSearchFriend[index]['userId'].toString(),
                        strGetPostUserId:
                            arrSearchFriend[index]['userId'].toString(),
                      ),
                    ),
                  );
                  //
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 100,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: navigationColor,
                    borderRadius: BorderRadius.circular(
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
    );
  }

  Column friendRequestListWB() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: 160,
          decoration: BoxDecoration(
            color: navigationColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0xffDDDDDD),
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0.1, 0.2),
              )
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(14.0),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: contGrindName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Friend...',
                ),
                onEditingComplete: () {
                  //do your stuff
                  if (kDebugMode) {
                    print('dismiss keybaord');
                  }
                  // dismiss keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  //
                  //
                  //
                  // QuickAlert.show(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   type: QuickAlertType.loading,
                  //   title: 'Please wait...',
                  //   text: 'searching...',
                  //   onConfirmBtnTap: () {
                  //     if (kDebugMode) {
                  //       print('some click');
                  //     }
                  //     //
                  //   },
                  // );
                  showLoadingUI(context, 'please wait...');
                  //
                  //

                  if (contGrindName.text == '') {
                    friendApiCall
                        .friendsWB(
                          strLoginUserId.toString(),
                          '1',
                        )
                        .then((value) => {
                              setState(() {
                                Navigator.pop(context);
                                arrSearchFriend = value;
                                strProfile = '1';
                              })
                            });
                  } else {
                    // HIT WEBSERVICE TO SEARCH FRIEND
                    searchFriendApiCall
                        .searchFriendsWB(
                          strLoginUserId.toString(),
                          contGrindName.text.toString(),
                        )
                        .then((value) => {
                              setState(() {
                                Navigator.pop(context);
                                arrSearchFriend = value;
                                if (kDebugMode) {
                                  print('dishant rajpuut 2.0');
                                  print(arrSearchFriend.length);
                                }

                                strProfile = '2';
                              })
                            });
                  }
                  //
                },
                // validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter grind name';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //
        ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          // scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: arrSearchFriend.length,
          itemBuilder: (context, index) {
            return (arrSearchFriend[index]['status'].toString() == '1')
                ? (arrSearchFriend[index]['profileId'].toString() ==
                        strLoginUserId.toString())
                    ? ListTile(
                        leading: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? (arrSearchFriend[index]['FirstUserimage']
                                        .toString() ==
                                    '')
                                ? Container(
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
                                  )
                                : Container(
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
                                        arrSearchFriend[index]['FirstUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  )
                            : (arrSearchFriend[index]['SecondUserimage']
                                        .toString() ==
                                    '')
                                ? Container(
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
                                  )
                                : Container(
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
                                        arrSearchFriend[index]
                                                ['SecondUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  ),
                        title: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? textWithBoldStyle(
                                //
                                arrSearchFriend[index]['FirstfullName']
                                    .toString(),
                                // '12',
                                //
                                Colors.black,
                                16.0,
                              )
                            : textWithBoldStyle(
                                //
                                arrSearchFriend[index]['SecondfullName']
                                    .toString(),
                                // '12',
                                //
                                Colors.black,
                                16.0,
                              ),
                        subtitle: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? textWithRegularStyle(
                                //
                                arrSearchFriend[index]['Firstemail'].toString(),
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
                                    arrSearchFriend[index]['userId'].toString())
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileNewScreen(
                                        strUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                        strGetPostUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileNewScreen(
                                        strUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                        strGetPostUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                      ),
                                    ),
                                  );
                            //
                          },
                          child: (arrSearchFriend[index]['status'].toString() ==
                                  '1')
                              ? (arrSearchFriend[index]['profileId']
                                          .toString() ==
                                      strLoginUserId.toString())
                                  ? Container(
                                      margin: const EdgeInsets.all(10.0),
                                      width: 120,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
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
                                      margin: const EdgeInsets.all(10.0),
                                      width: 100,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
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
                                    borderRadius: BorderRadius.circular(
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
                      )
                    : ListTile(
                        leading: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? (arrSearchFriend[index]['FirstUserimage']
                                        .toString() ==
                                    '')
                                ? Container(
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
                                  )
                                : Container(
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
                                        arrSearchFriend[index]['FirstUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  )
                            : (arrSearchFriend[index]['SecondUserimage']
                                        .toString() ==
                                    '')
                                ? Container(
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
                                  )
                                : Container(
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
                                        arrSearchFriend[index]
                                                ['SecondUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  ),
                        title: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? textWithBoldStyle(
                                //
                                arrSearchFriend[index]['FirstfullName']
                                    .toString(),
                                // '12',
                                //
                                Colors.black,
                                16.0,
                              )
                            : textWithBoldStyle(
                                //
                                arrSearchFriend[index]['SecondfullName']
                                    .toString(),
                                // '12',
                                //
                                Colors.black,
                                16.0,
                              ),
                        subtitle: (strLoginUserId ==
                                arrSearchFriend[index]['userId'].toString())
                            ? textWithRegularStyle(
                                //
                                arrSearchFriend[index]['Firstemail'].toString(),
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
                                    arrSearchFriend[index]['userId'].toString())
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileNewScreen(
                                        strUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                        strGetPostUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileNewScreen(
                                        strUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                        strGetPostUserId: arrSearchFriend[index]
                                                ['userId']
                                            .toString(),
                                      ),
                                    ),
                                  );
                            //
                          },
                          child: (arrSearchFriend[index]['status'].toString() ==
                                  '1')
                              ? (arrSearchFriend[index]['profileId']
                                          .toString() ==
                                      strLoginUserId.toString())
                                  ? Container(
                                      margin: const EdgeInsets.all(10.0),
                                      width: 120,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
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
                                      margin: const EdgeInsets.all(10.0),
                                      width: 100,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
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
                                    borderRadius: BorderRadius.circular(
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
                      )
                : Container(
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.amber,
                  );
          },
        ),
        //
      ],
    );
  }
//
}
