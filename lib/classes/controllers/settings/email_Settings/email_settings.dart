// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EmailSettingsScreen extends StatefulWidget {
  const EmailSettingsScreen(
      {super.key, required this.strLoginUserId, this.getEmailData});

  final String strLoginUserId;
  final getEmailData;

  @override
  State<EmailSettingsScreen> createState() => _EmailSettingsScreenState();
}

class _EmailSettingsScreenState extends State<EmailSettingsScreen> {
  //
  var arrData = [];
  var strUserSendNewRequest = '';
  var strAcceptRequest = '';
  var strTwoStepAuth = '';
  //
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('===================');
      print(widget.getEmailData);
      print('===================');
    }
    //

    //
    funcUpdatePrivacySetting();
    //
  }

  funcUpdatePrivacySetting() {
    // who can view your profile
    var strNotificationSendNewFriendRequest =
        widget.getEmailData['E_friend_request'].toString();

    if (strNotificationSendNewFriendRequest == '1') {
      strUserSendNewRequest = '1';
    } else if (strNotificationSendNewFriendRequest == '2') {
      strUserSendNewRequest = '2';
    }

    // who can view your post
    var strNotificationAcceptRejectFriendRequest =
        widget.getEmailData['E_friend_Accept_reject'].toString();

    if (strNotificationAcceptRejectFriendRequest == '1') {
      strAcceptRequest = '1';
    } else if (strNotificationAcceptRejectFriendRequest == '2') {
      strAcceptRequest = '2';
    }

    // who can view your friends
    var strNotificationUserSendChatMessage =
        widget.getEmailData['N_Chat_Message'].toString();

    if (strNotificationUserSendChatMessage == '1') {
      strTwoStepAuth = '1';
    } else if (strNotificationUserSendChatMessage == '2') {
      strTwoStepAuth = '2';
    }

    arrData = [
      {
        'title': 'When any user sends a new friend Request',
        'drop_down': strUserSendNewRequest.toString(),
      },
      {
        'title': 'When any user accepts/ reject their friend request',
        'drop_down': strAcceptRequest.toString(),
      },
      {
        'title': 'Two step authentication for account deletion',
        'drop_down': strTwoStepAuth.toString(),
      }
    ];
    if (kDebugMode) {
      print('<========================>');
      print(arrData);
      print('<========================>');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Email Settings',
          Colors.white,
          18.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'from_email_setting');
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
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 20,
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: arrData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: textWithBoldStyle(
                    //
                    arrData[index]['title'].toString(),
                    //
                    Colors.black,
                    14.0,
                  ),
                  trailing: (arrData[index]['drop_down'].toString() == '1')
                      ? GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print('object 1');
                            }
                            funcUpdateNotification(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 80,
                            // height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                //
                                'On',
                                //
                                Colors.white,
                                14.0,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print('object 1');
                            }
                            funcUpdateNotification(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 80,
                            // height: 100,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                //
                                'Off',
                                //
                                Colors.white,
                                14.0,
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

  //
  funcUpdateNotification(i) {
    if (kDebugMode) {
      print(arrData[i]);
    }
    //
    if (arrData[i]['drop_down'].toString() == '1') {
      //
      var custom = {
        'title': arrData[i]['title'].toString(),
        'drop_down': '2',
      };
      //
      arrData.removeAt(i);
      //
      arrData.insert(i, custom);
      //
      funcUploadDataWithOnlyText('2', i);
      //
    } else {
      //
      var custom = {
        'title': arrData[i]['title'].toString(),
        'drop_down': '1',
      };
      //
      arrData.removeAt(i);
      //
      arrData.insert(i, custom);
      //
      funcUploadDataWithOnlyText('1', i);
      //
    }
    //
    setState(() {});
    //
  }

  //
  funcUploadDataWithOnlyText(
    // keyIs,
    valueIs,
    indexIs,
  ) async {
    //
    //
    QuickAlert.show(
      context: context,
      // backgroundColor: white,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'updating...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    setState(() {
      // strPostType = 'loader';
    });
    //
    if (kDebugMode) {
      print('=====> POST : UPDATE PRIVACY');
      print(valueIs);
      print(indexIs);
      print(arrData[indexIs]);
    }

    // profilePrivacy
    // PostPrivacy
    // FriendPrivacy

    var key = '';
    var value = '';

    if (indexIs.toString() == '0') {
      //
      key = 'E_friend_request';
      value = valueIs.toString();
      //
    } else if (indexIs.toString() == '1') {
      // E_friend_Accept_reject =>
      key = 'E_friend_Accept_reject';
      value = valueIs.toString();
      //
    } else if (indexIs.toString() == '2') {
      //
      key = 'N_Chat_Message';
      value = valueIs.toString();
      //
    } else {
      //
      key = 'N_make_call';
      value = valueIs.toString();
      //
    }

    if (kDebugMode) {
      print(key);
      print(value);
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
          'action': 'setting',
          'userId': widget.strLoginUserId.toString(),
          key: value,
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
