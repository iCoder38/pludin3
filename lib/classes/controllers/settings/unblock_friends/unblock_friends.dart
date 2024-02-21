// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../database/database_helper.dart';

class UnblockFriendsScreen extends StatefulWidget {
  const UnblockFriendsScreen({super.key});

  @override
  State<UnblockFriendsScreen> createState() => _UnblockFriendsScreenState();
}

class _UnblockFriendsScreenState extends State<UnblockFriendsScreen> {
  //
  late DataBase handler;
  var strGetUserId = '';
  var arrBlockedUserlist = [];
  //
  @override
  void initState() {
    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
    super.initState();
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
                    strGetUserId = value[i].userId.toString(),

                    //
                  },
                //
                //
                QuickAlert.show(
                  context: context,
                  barrierDismissible: false,
                  type: QuickAlertType.loading,
                  title: 'Please wait...',
                  text: 'fetching...',
                  onConfirmBtnTap: () {
                    if (kDebugMode) {
                      print('some click');
                    }
                    //
                  },
                ),
                //
                funcListOfAllBlockedUsers(),
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
          'Blocked Friends',
          Colors.white,
          18.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        backgroundColor: navigationColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //
            const SizedBox(
              height: 20,
            ),
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: arrBlockedUserlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: (arrBlockedUserlist[index]['userId'].toString() ==
                          strGetUserId.toString())
                      ? (arrBlockedUserlist[index]['FirstUserimage']
                                  .toString() ==
                              '')
                          ? Container(
                              color: Colors.transparent,
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/icons/avatar.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              width: 60,
                              height: 60,
                              child: Opacity(
                                opacity: 0.4,
                                child: Image.network(
                                  //
                                  //
                                  arrBlockedUserlist[index]['FirstUserimage']
                                      .toString(),
                                  //
                                  fit: BoxFit.cover,
                                  //
                                ),
                              ),
                            )
                      : (arrBlockedUserlist[index]['SecondUserimage']
                                  .toString() ==
                              '')
                          ? Container(
                              color: Colors.transparent,
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/icons/avatar.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              width: 60,
                              height: 60,
                              child: Opacity(
                                opacity: 0.4,
                                child: Image.network(
                                  //
                                  //
                                  arrBlockedUserlist[index]['SecondUserimage']
                                      .toString(),
                                  //
                                  fit: BoxFit.cover,
                                  //
                                ),
                              ),
                            ),
                  title: (arrBlockedUserlist[index]['userId'].toString() ==
                          strGetUserId.toString())
                      ? textWithBoldStyle(
                          //
                          arrBlockedUserlist[index]['FirstfullName'].toString(),
                          //
                          Colors.black,
                          16.0,
                        )
                      : textWithBoldStyle(
                          //
                          arrBlockedUserlist[index]['SecondfullName']
                              .toString(),
                          //
                          Colors.black,
                          16.0,
                        ),
                  subtitle: (arrBlockedUserlist[index]['userId'].toString() ==
                          strGetUserId.toString())
                      ? textWithRegularStyle(
                          //
                          arrBlockedUserlist[index]['Firstemail'].toString(),
                          //
                          Colors.blueGrey,
                          14.0,
                        )
                      : textWithRegularStyle(
                          //
                          arrBlockedUserlist[index]['Secondemail'].toString(),
                          //
                          Colors.blueGrey,
                          14.0,
                        ),
                  trailing: GestureDetector(
                    onTap: () {
                      //
                      unblockPostFromMenu(
                        context,
                        arrBlockedUserlist[index]['profileId'].toString(),
                      );
                      //
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 100,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                          98,
                          210,
                          63,
                          1,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Center(
                        child: textWithBoldStyle(
                          'Unblock',
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
    );
  }

  //
  funcListOfAllBlockedUsers() async {
    //

    //
    if (kDebugMode) {
      print('=====> POST : BLOCKED LIST ');
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
          'action': 'blocklist',
          'userId': strGetUserId.toString(),
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
        arrBlockedUserlist.clear();
        //
        for (Map i in getData['data']) {
          arrBlockedUserlist.add(i);
        }
        if (kDebugMode) {
          print(arrBlockedUserlist);
        }
        Navigator.pop(context);
        setState(() {});
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

  //
  void unblockPostFromMenu(
    BuildContext context,
    String strProfileId,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Unblock'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              blockUserWB(
                strProfileId.toString(),
              );
              //
            },
            child: textWithRegularStyle(
              'Unblock',
              Colors.red,
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
              Colors.black,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  blockUserWB(
    strGetFriendIdIs,
  ) async {
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'un-blocking...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
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
          'action': 'block_unblock_friend',
          'userId': strGetUserId.toString(),
          'profileId': strGetFriendIdIs.toString(),
          'status': '0',
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
// success
        /* QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: getData['msg'],
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.pop(context);
            //
            //  Navigator.pushNamed(context, 'push_to_home_screen');
            //
          },
        );*/
        //
        funcListOfAllBlockedUsers();
        //
      } else {
        if (kDebugMode) {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Something went wrong. Please try again later.'.toString(),
          );
        }
      }
    } else {
      // return postList;
    }
  }
}
