// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// import 'package:flutter_switch/flutter_switch.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen(
      {super.key, required this.strLoginUserId, this.getPNotificationData});

  final String strLoginUserId;
  final getPNotificationData;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  //
  var arrData = [
    {
      'title': 'When any user sends a new friend Request',
      'switch': '0',
    },
    {
      'title': 'When any user accepts/ reject their friend request',
      'switch': '1',
    },
    {
      'title': 'When any user sends chat messages',
      'switch': '0',
    },
    {
      'title': 'When any user makes an audio /video call',
      'switch': '1',
    }
  ];
  //
  var strSendNewRequest = '';
  var strAcceptReject = '';
  var strSendChatMessage = '';
  var strMakeCall = '';
  //
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.getPNotificationData);
    }
    //

    //
    funcUpdatePrivacySetting();
    //
  }

  funcUpdatePrivacySetting() {
    // who can view your profile
    var strNotificationSendNewFriendRequest =
        widget.getPNotificationData['N_friend_request'].toString();

    if (strNotificationSendNewFriendRequest == '1') {
      strSendNewRequest = '1';
    } else if (strNotificationSendNewFriendRequest == '2') {
      strSendNewRequest = '2';
    }

    // who can view your post
    var strNotificationAcceptRejectFriendRequest =
        widget.getPNotificationData['N_friend_Accept_reject'].toString();

    if (strNotificationAcceptRejectFriendRequest == '1') {
      strAcceptReject = '1';
    } else if (strNotificationAcceptRejectFriendRequest == '2') {
      strAcceptReject = '2';
    }

    // who can view your friends
    var strNotificationUserSendChatMessage =
        widget.getPNotificationData['N_Chat_Message'].toString();

    if (strNotificationUserSendChatMessage == '1') {
      strSendChatMessage = '1';
    } else if (strNotificationUserSendChatMessage == '2') {
      strSendChatMessage = '2';
    }

    // who can view your picture
    var strNotificationMakeAudioVideo =
        widget.getPNotificationData['N_make_call'].toString();

    if (strNotificationMakeAudioVideo == '1') {
      strMakeCall = '1';
    } else if (strNotificationMakeAudioVideo == '2') {
      strMakeCall = '2';
    }

    arrData = [
      {
        'title': 'When any user sends a new friend Request',
        'drop_down': strSendNewRequest.toString(),
      },
      {
        'title': 'When any user accepts/ reject their friend request',
        'drop_down': strAcceptReject.toString(),
      },
      {
        'title': 'When any user sends chat messages',
        'drop_down': strSendChatMessage.toString(),
      },
      {
        'title': 'When any user makes and audio /video call',
        'drop_down': strMakeCall.toString(),
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
    //

    //
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Notification Settings',
          Colors.white,
          18.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'from_notification_setting');
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
                  const Divider(),
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
                            //
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
                              print('object 2');
                            }
                            //
                            funcUpdateNotification(index);
                            //
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
      key = 'N_friend_request';
      value = valueIs.toString();
      //
    } else if (indexIs.toString() == '1') {
      //
      key = 'N_friend_Accept_reject';
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
