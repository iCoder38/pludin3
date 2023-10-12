// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, prefer_final_fields, use_build_context_synchronously
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAudioCallScreen extends StatefulWidget {
  const NewAudioCallScreen(
      {super.key, this.getFullDetailsOfThatDialog, required this.callStatus});

  final getFullDetailsOfThatDialog;
  final String callStatus;

  @override
  State<NewAudioCallScreen> createState() => _NewAudioCallScreenState();
}

class _NewAudioCallScreenState extends State<NewAudioCallScreen> {
  //
  var localCallStatus = '0';
  //
  //
  var strLoginUserId = '';
  var strLoginUserName = '';
  var strLoginUserImage = '';
  var strLoginUserFirebaseId = '';
  //
  var strOtherUserName = '';
  var strOtherUserImage = '';
  var strOtherFirebaseId = '';
  //
  late DataBase handler;
  //
  // agota kit
  String channelName = '';
  String token = '';
  int uid = 0;
  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;
  //
  var strUserGetCall = '0';
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    //
    // final now = Duration(seconds: 30);
    // print("${_printDuration(now)}");
    //
    // String sDuration = "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";

    handler = DataBase();
    //
    if (kDebugMode) {
      print('=============================================');
      print('=========== IN AUDIO CALL SCREEN ============');
      print(widget.getFullDetailsOfThatDialog);
      print(widget.callStatus);
      // print(widget.getFullDetailsOfThatDialog['']);
      print('=============================================');
      print('=============================================');
    }

//

    //
    //

    //
    funcGetLocalDBdata();
    //
    localCallStatus = '0';
    //

    if (widget.callStatus == 'get_call') {
      channelName = widget.getFullDetailsOfThatDialog['channelName'].toString();
    } else {
      channelName =
          '${widget.getFullDetailsOfThatDialog['sender_firebase_id'].toString()}+${widget.getFullDetailsOfThatDialog['receiver_firebase_id'].toString()}';
    }

    print('=============================================');
    print('=============================================');
    print(channelName);
    print('=============================================');
    print('=============================================');

    super.initState();
  }

  //
  // get local db
  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
        //
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
                    strLoginUserId = value[i].userId.toString(),
                    strLoginUserName = value[i].fullName.toString(),
                    strLoginUserImage = value[i].image.toString(),
                    strLoginUserFirebaseId = value[i].firebaseId.toString(),
                    //
                    funcRefreshScreenAndInitAgora(),
                    //
                  },
              });
        }
      },
    );
    //
  }

  //
  funcRefreshScreenAndInitAgora() {
    // init agora first
    if (kDebugMode) {
      print('=====> agora init DONE');
    }
    setupVoiceSDKEngine();
    //
    //
    if (!mounted) return;
    setState(() {
      //
      if (widget.getFullDetailsOfThatDialog['sender_firebase_id'].toString() ==
          strLoginUserFirebaseId.toString()) {
        //
        strOtherUserName =
            widget.getFullDetailsOfThatDialog['receiver_name'].toString();
        strOtherUserImage =
            widget.getFullDetailsOfThatDialog['receiver_image'].toString();
        strOtherFirebaseId = widget
            .getFullDetailsOfThatDialog['receiver_firebase_id']
            .toString();
      } else {
        strOtherUserName =
            widget.getFullDetailsOfThatDialog['sender_name'].toString();
        strOtherUserImage =
            widget.getFullDetailsOfThatDialog['sender_image'].toString();
        strOtherFirebaseId =
            widget.getFullDetailsOfThatDialog['sender_firebase_id'].toString();
      }
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: whoMakeTheCallUI(context),
    );
  }

  Column whoMakeTheCallUI(BuildContext context) {
    return Column(
      children: [
        //
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: (localCallStatus == '0')
                  ? IconButton(
                      onPressed: () {
                        //
                        Navigator.pop(context);
                        //
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ),
          ),
        ),
        //
        Expanded(
          flex: 4,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Column(
              children: [
                //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: (localCallStatus == '0')
                                ? Container(
                                    height: 140,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        70.0,
                                      ),
                                    ),
                                    child: (strOtherUserImage == '')
                                        ? Image.asset(
                                            'assets/icons/avatar.png',
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              70.0,
                                            ),
                                            child: Image.network(
                                              strOtherUserImage.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  )
                                : Container(
                                    height: 140,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        70.0,
                                      ),
                                    ),
                                    child: (strOtherUserImage == '')
                                        ? Image.asset(
                                            'assets/icons/avatar.png',
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              70.0,
                                            ),
                                            child: Image.network(
                                              strOtherUserImage.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                          ),
                          //

                          //
                          if (localCallStatus == '1')
                            textWithRegularStyle(
                              //
                              'waiting for $strOtherUserName to join...',
                              //
                              Colors.black,
                              18.0,
                            )
                          else if (localCallStatus == '3')
                            textWithBoldStyle(
                              //
                              strOtherUserName.toString(),
                              //
                              Colors.black,
                              18.0,
                            )
                          else
                            textWithBoldStyle(
                              //
                              strOtherUserName.toString(),
                              //
                              Colors.black,
                              18.0,
                            ),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
                //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  70.0,
                                ),
                              ),
                              child: (strLoginUserImage == '')
                                  ? Image.asset(
                                      'assets/icons/avatar.png',
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        70.0,
                                      ),
                                      child: Image.network(
                                        strLoginUserImage.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          //
                          const SizedBox(
                            height: 20,
                          ),
                          //
                          textWithBoldStyle(
                            //
                            strLoginUserName.toString(),
                            //
                            Colors.black,
                            18.0,
                          ),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
                //
              ],
            ),
          ),
        ),
        //r
        if (localCallStatus == '0') ...[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  GestureDetector(
                    onTap: () {
                      //
                      if (!mounted) return;
                      setState(() {
                        localCallStatus = '1';
                      });

                      //
                      funcGetDeviceTokenFromXMPP();
                      //
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: const Offset(
                              0,
                              3,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: textWithBoldStyle(
                          'Call',
                          Colors.white,
                          18.0,
                        ),
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          )
        ] else if (localCallStatus == '1' || localCallStatus == '3') ...[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  GestureDetector(
                    onTap: () {
                      //
                      leave();
                      // showLoadingUI(context, 'please wait...');
                      //
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: const Offset(
                              0,
                              3,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: textWithBoldStyle(
                          'End',
                          Colors.white,
                          18.0,
                        ),
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ]

        //
      ],
    );
  }

  //
  // register
  //
  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(
      RtcEngineContext(
        appId: appId,
        // channelProfile: ''
      ),
    );

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          // showMessage(

          if (kDebugMode) {
            print(
                "Local user uid ====> :${connection.localUid} joined the channel 2");
          }

          if (!mounted) return;
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          // showMessage("Remote user uid:$remoteUid joined the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid joined the channel");
          }
          if (!mounted) return;
          setState(() {
            _remoteUid = remoteUid;
            localCallStatus = '3';
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // showMessage("Remote user uid:$remoteUid left the channel");

          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }
          //
          if (!mounted) return;
          setState(() {
            leave();
          });
          //
        },
      ),
    );
  }

  funcGetDeviceTokenFromXMPP() {
    //
    showLoadingUI(context, 'please wait...');
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}member")
        .doc("India")
        .collection("details")
        .where("firebaseId", isEqualTo: strOtherFirebaseId.toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }
        //
        Navigator.pop(context);
        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          /*if (kDebugMode) {
            print(element.id);
            print(element.data()['firebaseId']);
            print(element.data()['deviceToken']);
            print(element.data()['device']);
            // print(element.id.runtimeType);
          }*/
          //
          funcSendNotification(
            element.data()['deviceToken'].toString(),
            element.data()['firebaseId'].toString(),
            element.data()['device'].toString(),
          );
        }
      }
    });

    //
  }

  funcSendNotification(
    getDeviceToken,
    getFirebaseId,
    getDevice,
  ) async {
    // upload feeds data to time line

    //
    /*
     [action] => groupsentnotification
    [message] => 
    [userId] => Yg3764MgSeS4Vutp96ldyLHabHo1
    [name] => neema
    [image] => https://demo4.evirtualservices.net/pludin/img/uploads/users/1690283219image_picker_3DAF8074-715C-431C-8F2A-290CA0402C04-473-00000014264D3CD8.jpg
    [deviceJson] => [{"device":"Android","deviceToken":"dc8Ajo9NTda4p69WKqzcNl:APA91bE34U1CGtaJXAHKm8YGUQsRB5sc33iWdE_PljFspR0A8T9LVzmcqvQMhsbtYJyO_OFS5XhG3yuP65-91eN69te4KjW2SAQYRgnCjMBototEp64U2aStKVmR05w--LfZJjswsnDO"}]
    [type] => audioCall
    [channelName] */
    // showLoadingUI(context, 'uploading...');
    //
    if (kDebugMode) {
      print('=====> POST : SEND NOTIFICATION <===== ');
      print(getDeviceToken);
      print(getFirebaseId);
      print(getDevice);
    }

    var customJsonArray = [
      {
        'device': getDevice.toString(),
        'deviceToken': getDeviceToken.toString(),
      }
    ];

    if (kDebugMode) {
      print(customJsonArray);
    }

    String encoded = jsonEncode(customJsonArray);

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'action': 'groupsentnotification',
          'message': 'Incoming Audio Call',
          'userId': strLoginUserFirebaseId.toString(),
          'name': strLoginUserName.toString(),
          'image': strLoginUserImage.toString(),
          'deviceJson': encoded,
          'type': 'audioCall',
          'channelName': channelName.toString(),
        },
      ),
    );

    // convert data to dict
    var data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(data);
    }

    if (resposne.statusCode == 200) {
      if (data['status'].toString().toLowerCase() == 'success') {
        //
        //
        Navigator.pop(context);
        //
        join();

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

  // JOIN CHANNEL METHOD
  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName.toString(),
      options: options,
      uid: uid,
    );
  }

  //
  // LEAVE
  void leave() {
    // dispose();
    if (!mounted) return;
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel().then((value) => {
          setState(() {
            localCallStatus = '0';
            Navigator.pop(context);
          }),
        });
  }

  //
  // Clean up the resources when you leave
  @override
  void dispose() {
    // print('dispo');
    agoraEngine.leaveChannel();
    // dispose();
    super.dispose();
  }
}
