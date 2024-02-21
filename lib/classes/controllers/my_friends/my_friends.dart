// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/my_friends/my_friend_new_modal/my_friends_new_modal.dart';
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
  var screen_loader = '0';
  var screen_message_alert_message = '0';
  final MyFriendsList my_friends_list = MyFriendsList();
  //
  int segmentedControlValue = 0;
  //
  var strFriendLoader = '0';
  late DataBase handler;
  var strLoginUserId = '';
  var arrSearchFriend = [];
  //
  var str_user_select_which_profile = '1';
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
                func_call_api(
                  strLoginUserId,
                  '2',
                  '0',
                ),
                /*friendApiCall
                    .friendsWB(
                      strLoginUserId.toString(),
                      '2',
                    )
                    .then((value) => {
                          setState(() {
                            arrSearchFriend = value;
                            strFriendLoader = '1';
                          })
                        }),*/
                //
              });
        }
      },
    );
    //
  }

  func_call_api(login_user_id, status, type) {
    //
    setState(() {
      screen_loader = '1';
    });
    my_friends_list
        .funcMyFriendsListOrRequestWB(
          login_user_id.toString(),
          status,
          type,
        )
        .then((value) => {
              //
              print(value),
              //
              arrSearchFriend = value,
              print(arrSearchFriend.length),
              if (arrSearchFriend.isEmpty)
                {
                  //
                  print(type),
                  if (type == '1')
                    {
                      screen_message_alert_message = 'No data found',
                    }
                  else if (type == '2')
                    {
                      screen_message_alert_message =
                          'You have not received any new friend request yet.',
                    }
                  else
                    {
                      screen_message_alert_message = 'No request found',
                    },

                  //
                  setState(() {
                    screen_loader = '2';
                  }),
                }
              else
                {
                  //

                  setState(() {
                    screen_loader = '0';
                  }),
                }
            });
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
      body: Column(
        children: [
          //
          tabs_UI(context),

          if (str_user_select_which_profile == '1') ...[
            //
            if (screen_loader == '1') ...[
              const CircularProgressIndicator()
            ] else if (screen_loader == '2') ...[
              textWithRegularStyle(
                //
                screen_message_alert_message,
                Colors.black,
                14.0,
              ),
            ] else ...[
              friends_UI(),
            ]
          ] else if (str_user_select_which_profile == '2') ...[
            //
            if (screen_loader == '1') ...[
              const CircularProgressIndicator()
            ] else if (screen_loader == '2') ...[
              const SizedBox(
                height: 150.0,
              ),
              Center(
                child: textWithRegularStyle(
                  //
                  screen_message_alert_message,
                  Colors.black,
                  14.0,
                ),
              ),
            ] else ...[
              new_request_UI(),
            ]
          ] else if (str_user_select_which_profile == '3') ...[
            //
            if (screen_loader == '1') ...[
              const CircularProgressIndicator()
            ] else if (screen_loader == '2') ...[
              const SizedBox(
                height: 150.0,
              ),
              Center(
                child: textWithRegularStyle(
                  //
                  screen_message_alert_message,
                  Colors.black,
                  14.0,
                ),
              ),
            ] else ...[
              request_sent_UI(),
            ]
          ]
        ],
      ),
    );
  }

  ListView friends_UI() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrSearchFriend.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: (strLoginUserId.toString() ==
                  arrSearchFriend[index]['userId'].toString())
              ? textWithBoldStyle(
                  arrSearchFriend[index]['FirstfullName'].toString(),
                  Colors.black,
                  14.0,
                )
              : textWithBoldStyle(
                  arrSearchFriend[index]['SecondfullName'].toString(),
                  Colors.black,
                  14.0,
                ),
          subtitle: textWithRegularStyle(
            //
            (strLoginUserId.toString() ==
                    arrSearchFriend[index]['userId'].toString())
                ? arrSearchFriend[index]['Firstemail'].toString()
                : arrSearchFriend[index]['Secondemail'].toString(),
            Colors.black,
            12.0,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: (strLoginUserId.toString() ==
                      arrSearchFriend[index]['userId'].toString())
                  ? (arrSearchFriend[index]['FirstSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['FirstUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['FirstUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            )
                  : (arrSearchFriend[index]['SecondSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['SecondUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['SecondUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
            ),
          ),
          trailing: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: navigationColor,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Center(
              child: textWithRegularStyle(
                'Friends',
                Colors.white,
                12.0,
              ),
            ),
          ),
          onTap: () {
            print('====> USER CLICKED FRIENDS <=====');
            print(arrSearchFriend[index]);
            (strLoginUserId.toString() ==
                    arrSearchFriend[index]['userId'].toString())
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileNewScreen(
                        strUserId: arrSearchFriend[index]['userId'].toString(),
                        strGetPostUserId:
                            arrSearchFriend[index]['profileId'].toString(),
                      ),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileNewScreen(
                        strUserId:
                            arrSearchFriend[index]['profileId'].toString(),
                        strGetPostUserId:
                            arrSearchFriend[index]['userId'].toString(),
                      ),
                    ),
                  );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MyProfileScreen(
            //       strUserId: arrSearchFriend[index]['userId'].toString(),
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }

  Container tabs_UI(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Colors.redAccent,
      child: Row(
        children: [
          //
          Expanded(
            child: GestureDetector(
              onTap: () {
                //
                setState(() {
                  str_user_select_which_profile = '1';
                });
                //

                func_call_api(
                  strLoginUserId,
                  '2',
                  '0',
                );
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Center(
                  child: (str_user_select_which_profile == '1')
                      ? textWithBoldStyle(
                          'Friends',
                          Colors.white,
                          16.0,
                        )
                      : textWithRegularStyle(
                          'Friends',
                          Colors.white,
                          12.0,
                        ),
                ),
              ),
            ),
          ),
          //
          Container(
            height: 40,
            width: 0.4,
            color: Colors.black,
          ),
          //
          Expanded(
            child: GestureDetector(
              onTap: () {
                //
                arrSearchFriend.clear();
                setState(() {
                  str_user_select_which_profile = '2';
                });
                //
                func_call_api(
                  strLoginUserId,
                  '1',
                  '2',
                );
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Center(
                  child: (str_user_select_which_profile == '2')
                      ? textWithBoldStyle(
                          'New Request',
                          Colors.white,
                          16.0,
                        )
                      : textWithRegularStyle(
                          'New Request',
                          Colors.white,
                          12.0,
                        ),
                ),
              ),
            ),
          ),
          //
          Container(
            height: 40,
            width: 0.4,
            color: Colors.black,
          ),
          //
          Expanded(
            child: GestureDetector(
              onTap: () {
                //
                arrSearchFriend.clear();
                setState(() {
                  str_user_select_which_profile = '3';
                });
                //
                func_call_api(
                  strLoginUserId,
                  '1',
                  '1',
                );
              },
              child: Container(
                height: 60,
                color: Colors.transparent,
                child: Center(
                  child: (str_user_select_which_profile == '3')
                      ? textWithBoldStyle(
                          'Request Sent',
                          Colors.white,
                          16.0,
                        )
                      : textWithRegularStyle(
                          'Request Sent',
                          Colors.white,
                          12.0,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView request_sent_UI() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrSearchFriend.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: (strLoginUserId.toString() ==
                  arrSearchFriend[index]['userId'].toString())
              ? textWithBoldStyle(
                  arrSearchFriend[index]['FirstfullName'].toString(),
                  Colors.black,
                  14.0,
                )
              : textWithBoldStyle(
                  arrSearchFriend[index]['SecondfullName'].toString(),
                  Colors.black,
                  14.0,
                ),
          subtitle: textWithRegularStyle(
            //
            (strLoginUserId.toString() ==
                    arrSearchFriend[index]['userId'].toString())
                ? arrSearchFriend[index]['Firstemail'].toString()
                : arrSearchFriend[index]['Secondemail'].toString(),
            Colors.black,
            12.0,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: (strLoginUserId.toString() ==
                      arrSearchFriend[index]['userId'].toString())
                  ? (arrSearchFriend[index]['FirstSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['FirstUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['FirstUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            )
                  : (arrSearchFriend[index]['SecondSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['SecondUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['SecondUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
            ),
          ),
          trailing: Container(
            height: 40,
            width: 110,
            decoration: BoxDecoration(
              color: navigationColor,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Center(
              child: textWithRegularStyle(
                'Request sent',
                Colors.white,
                12.0,
              ),
            ),
          ),
          onTap: () {
            //
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProfileScreen(
                  strUserId: arrSearchFriend[index]['profileId'].toString(),
                ),
              ),
            );*/
            (strLoginUserId.toString() ==
                    arrSearchFriend[index]['userId'].toString())
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileNewScreen(
                        strUserId: arrSearchFriend[index]['userId'].toString(),
                        strGetPostUserId:
                            arrSearchFriend[index]['profileId'].toString(),
                      ),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileNewScreen(
                        strUserId:
                            arrSearchFriend[index]['profileId'].toString(),
                        strGetPostUserId:
                            arrSearchFriend[index]['userId'].toString(),
                      ),
                    ),
                  );
            //
          },
        );
      },
    );
  }

  ListView new_request_UI() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrSearchFriend.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: (strLoginUserId.toString() ==
                  arrSearchFriend[index]['userId'].toString())
              ? textWithBoldStyle(
                  arrSearchFriend[index]['FirstfullName'].toString(),
                  Colors.black,
                  14.0,
                )
              : textWithBoldStyle(
                  arrSearchFriend[index]['SecondfullName'].toString(),
                  Colors.black,
                  14.0,
                ),
          subtitle: textWithRegularStyle(
            //
            (strLoginUserId.toString() ==
                    arrSearchFriend[index]['userId'].toString())
                ? arrSearchFriend[index]['Firstemail'].toString()
                : arrSearchFriend[index]['Secondemail'].toString(),
            Colors.black,
            12.0,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: (strLoginUserId.toString() ==
                      arrSearchFriend[index]['userId'].toString())
                  ? (arrSearchFriend[index]['FirstSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['FirstUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['FirstUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            )
                  : (arrSearchFriend[index]['SecondSettingProfilePicture']
                              .toString() !=
                          '1')
                      ? Image.asset(
                          'assets/images/1024.png',
                          fit: BoxFit.cover,
                        )
                      : (arrSearchFriend[index]['SecondUserimage'].toString() ==
                              '')
                          ? Image.asset(
                              'assets/images/1024.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              arrSearchFriend[index]['SecondUserimage']
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
            ),
          ),
          trailing: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: navigationColor,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Center(
              child: textWithRegularStyle(
                'New Request',
                Colors.white,
                12.0,
              ),
            ),
          ),
          onTap: () {
            openFriendsSettingPOPUP(
              context,
              arrSearchFriend[index],
            );
            /**/
          },
        );
      },
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

  //
  //
  void openFriendsSettingPOPUP(BuildContext context, data) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Friends'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              print(data);
              (strLoginUserId.toString() == data['userId'].toString())
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileNewScreen(
                          strUserId: data['userId'].toString(),
                          strGetPostUserId: data['profileId'].toString(),
                        ),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileNewScreen(
                          strUserId: data['profileId'].toString(),
                          strGetPostUserId: data['userId'].toString(),
                        ),
                      ),
                    );
            },
            child: textWithRegularStyle(
              'View profile',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              print(data);
              (strLoginUserId.toString() == data['userId'].toString())
                  ? accept_WB(data['profileId'].toString())
                  : accept_WB(data['userId'].toString());
              //
            },
            child: textWithRegularStyle(
              'Accept request',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              print(data);
              (strLoginUserId.toString() == data['userId'].toString())
                  ? accept_WB(data['profileId'].toString())
                  : accept_WB(data['userId'].toString());
            },
            child: textWithRegularStyle(
              'Decline request',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.red,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  // upload feeds data to time line
  blockUserWB(
    strGetFriendIdIs,
  ) async {
    //
    print(strGetFriendIdIs);
    showLoadingUI(context, 'please wait...');

    //
    if (kDebugMode) {
      print('=====> POST : UPLOAD ONLY TEXT ');
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'frienddecline',
          'userId': strLoginUserId.toString(),
          'profileId': strGetFriendIdIs.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        Navigator.pop(context);
        arrSearchFriend.clear();
        setState(() {
          str_user_select_which_profile = '2';
        });
        //
        func_call_api(
          strLoginUserId,
          '1',
          '2',
        );
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }

  // upload feeds data to time line
  accept_WB(
    strGetFriendIdIs,
  ) async {
    //
    print(strGetFriendIdIs);
    showLoadingUI(context, 'please wait...');

    //
    if (kDebugMode) {
      print('=====> POST : ACCEPT REQUEST');
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'sendacceptfriend',
          'userId': strLoginUserId.toString(),
          'profileId': strGetFriendIdIs.toString(),
          'status': '2',
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        Navigator.pop(context);
        arrSearchFriend.clear();
        setState(() {
          str_user_select_which_profile = '2';
        });
        //
        func_call_api(
          strLoginUserId,
          '1',
          '2',
        );
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }
}
