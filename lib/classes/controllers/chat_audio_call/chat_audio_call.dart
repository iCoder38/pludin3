/*import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pludin/classes/controllers/chat_audio_call/chat_audio_user_image.dart';
import 'package:pludin/classes/header/utils.dart';

import '../database/database_helper.dart';

import 'package:uuid/uuid.dart';

class ChatAudioCallScreen extends StatefulWidget {
  const ChatAudioCallScreen(
      {super.key, this.getAllData, required this.strGetCallStatus});

  final getAllData;
  final String strGetCallStatus;

  @override
  State<ChatAudioCallScreen> createState() => _ChatAudioCallScreenState();
}

class _ChatAudioCallScreenState extends State<ChatAudioCallScreen> {
  //
  var strTotalMember = [];
  //
  String channelName = '';
  // String channelName = "dishu-12345";
  String token = '';

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  //
  var strCallStatus = '';
  //
  late DataBase handler;
  //
  var strLoginUserId = '';
  var strLoginUserName = '';
  var strLoginUserImage = '';
  var strLoginUserFirebaseId = '';
  //
  // receiver
  var strReceiverId = '';
  var strReceiverName = '';
  var strReceiverImage = '';
  var strReceiverFirebaseId = '';
  //
  var uuid = const Uuid().v4();
  var strUUIDcreator = '';
  //
  @override
  void initState() {
    super.initState();
    // create uuid
    // print(widget.getAllData);
    //

    //
    //
    handler = DataBase();
    //
    //
    strCallStatus = widget.strGetCallStatus.toString();
    //
    if (kDebugMode) {
      print(widget.getAllData);

      print('========= USER ID IS =============');
      print(widget.getAllData['userId'.toString()]);

      print('========= UUID =============');
      print(uuid.toString());
      print('========= UUID =============');
      print(strCallStatus);
      //
      funcSendNotificationToUsers(
          'd2jY56J8RDCqm0ZM9ROn4J:APA91bFiJRswCC5_tsrvpnFYm8_ZCuvLtuVkRigRR--IUvnfrUsdOSPP-nWfeo13LCD5DGbzkDxx7ytBtbnqfF4RAke5v5KeeucOmogBrY1QuuTQyVmT8Zo3ScMimsLtl-prF_ejvcF6');
      //
    }
    //
    if (strCallStatus == 'make_call') {
      // testing
      strUUIDcreator = '12345';

      ///
      ///
      ///
      // production
      // strUUIDcreator = uuid.toString();
      //
    } else {
      // testing
      strUUIDcreator = '12345';
      // print(widget.getAllData);
      ///
      ///
      ///
      // production
      // strUUIDcreator = widget.getAllData['channel_name'].toString();
    }

    if (kDebugMode) {
      print('========= CHANNEL NAME =============');
      print(strUUIDcreator);
      print('====================================');
    }

    //  INITIALIZE AGORA ENGINE
    //
    setupVoiceSDKEngine();
    //

    //
    //
    funcGetLocalDBdata();
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
                    strLoginUserId = value[i].userId.toString(),
                    strLoginUserName = value[i].fullName.toString(),
                    strLoginUserImage = value[i].image.toString(),
                    strLoginUserFirebaseId = value[i].image.toString(),
                    //
                    // funcAddUsersInArray(),
                    //
                  },
              });
        }
      },
    );
    //
  }

  //
  // funcAddUsersInArray() {
  //   if (strLoginUserFirebaseId ==
  //       widget.getAllData['sender_firebase_id'].toString()) {
  //     if (kDebugMode) {
  //       print('one');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('two');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 20.0,
              ),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              // height: 60.0,
              child: Row(
                children: [
                  (strCallStatus == 'make_call')
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: NeoPopButton(
                            color: Colors.white,
                            // onTapUp: () => HapticFeedback.vibrate(),
                            onTapUp: () {
                              //
                              Navigator.pop(context);
                            },
                            onTapDown: () => HapticFeedback.vibrate(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.chevron_left,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        )
                ],
              ),
            ),
          ),
          //
          // Row(
          //   children: [
          Expanded(
            flex: 2,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(
                      "${strFirebaseMode}call/audio/$strUUIDcreator",
                    )
                    .where(
                      'channel_name',
                      isEqualTo: strUUIDcreator,
                    )
                    // .get(),
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    //
                    var getSnapShopValue = snapshot.data!.docs.toList();
                    if (kDebugMode) {
                      print('====> FIREBASE AUDIO CALL USERS 1.0 <=====');
                      print(getSnapShopValue);
                      print(getSnapShopValue.length);

                      print('====> FIREBASE AUDIO CALL USERS 1 <=====');
                    }
                    if (getSnapShopValue.isEmpty) {
                      // Navigator.pop(context);
                      // return;
                    }
                    //
                    return Container(
                      color: Colors.transparent,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: getSnapShopValue.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (kDebugMode) {
                            print('======> TOTAL USERS IN  ARRAY<======');

                            print('====================================');
                          }
                          return Container(
                            // height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.amber[600],
                                borderRadius: BorderRadius.circular(
                                  70.0,
                                ),
                              ),
                              child: Center(
                                child: textWithRegularStyle(
                                  getSnapShopValue[index]['name'].toString(),
                                  Colors.black,
                                  14.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ), /*SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*for (int i = 0;
                                i < getSnapShopValue.length;
                                i++) ...[
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.amber[600],
                                width: 140,
                                height: 140,
                                child: textWithRegularStyle(
                                  getSnapShopValue[i]['name'].toString(),
                                  Colors.black,
                                  14.0,
                                ),
                                // child: widget)
                                //   ],
                              ),
                            ]*/
                          ],
                        ),
                      ),*/
                    );
                  } else if (snapshot.hasError) {
                    // return Center(
                    //   child: Text(
                    //     'Error: ${snapshot.error}',
                    //   ),

                    // );
                    if (kDebugMode) {
                      print(snapshot.error);
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          //

// MAKE CALL
          if (strCallStatus == 'make_call') ...[
            Expanded(
              child: Container(
                color: const Color.fromRGBO(
                  246,
                  248,
                  253,
                  1,
                ),
                width: MediaQuery.of(context).size.width,
                height: 48.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 40,
                          left: 40,
                        ),
                        height: 30,
                        width: 140,
                        child: NeoPopButton(
                          color: Colors.white,
                          // onTapUp: () => HapticFeedback.vibrate(),
                          onTapUp: () {
                            // agora join
                            join();
                            //
                            funcSendNotificationToUsers(
                              widget.getAllData['deviceToken'].toString(),
                            );
                            //
                            if (!mounted) return;
                            setState(() {
                              strCallStatus = 'make_call_pick_up';
                            });
                          },
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'Call',
                                Colors.green,
                                18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ] else if (strCallStatus == 'make_call_pick_up') ...[
            Expanded(
              child: Container(
                color: const Color.fromRGBO(
                  246,
                  248,
                  253,
                  1,
                ),
                // width: MediaQuery.of(context).size.width,
                height: 48.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                          left: 40,
                        ),
                        height: 60,
                        // width: 140,
                        child: NeoPopButton(
                          color: Colors.white,
                          // onTapUp: () => HapticFeedback.vibrate(),
                          onTapUp: () {
                            // agora leave
                            leave();
                            //
                            if (!mounted) return;
                            setState(() {
                              strCallStatus = 'make_call';
                            });
                            // REMOVE USER FROM FIREBASE
                            funcRemoveUserFromXMPP();
                            //
                          },
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'End call',
                                Colors.red,
                                18.0,
                              ),
                            ],
                            //
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      height: 50,
                      width: 80,
                      child: NeoPopButton(
                        color: Colors.white,
                        // onTapUp: () => HapticFeedback.vibrate(),
                        onTapUp: () {
                          // agora leave
                          // leave();
                          //
                          if (!mounted) return;
                          setState(() {
                            strCallStatus = 'make_call';
                          });
                        },
                        onTapDown: () => HapticFeedback.vibrate(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textWithBoldStyle(
                              '00:00',
                              Colors.green,
                              18.0,
                            ),
                          ],
                          //
                        ),
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
          ] else if (strCallStatus == 'get_call') ...[
            Expanded(
              child: Container(
                color: const Color.fromRGBO(
                  246,
                  248,
                  253,
                  1,
                ),
                width: MediaQuery.of(context).size.width,
                height: 48.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 40,
                          left: 40,
                        ),
                        height: 30,
                        width: 140,
                        child: NeoPopButton(
                          color: Colors.white,
                          // onTapUp: () => HapticFeedback.vibrate(),
                          onTapUp: () {
                            // agora join
                            join();
                            //
                            if (!mounted) return;
                            setState(() {
                              strCallStatus = 'get_call_pick_up';
                            });
                          },
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'Accept',
                                Colors.green,
                                18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ] else if (strCallStatus == 'get_call_pick_up') ...[
            Expanded(
              child: Container(
                color: const Color.fromRGBO(
                  246,
                  248,
                  253,
                  1,
                ),
                width: MediaQuery.of(context).size.width,
                height: 48.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 40,
                          left: 40,
                        ),
                        height: 30,
                        width: 140,
                        child: NeoPopButton(
                          color: Colors.white,
                          // onTapUp: () => HapticFeedback.vibrate(),
                          onTapUp: () {
                            // agora leave
                            leave();
                            //
                            if (!mounted) return;
                            setState(() {
                              strCallStatus = 'get_call';
                            });
                            //
                            funcRemoveUserFromXMPP();
                            //
                          },
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'End call',
                                Colors.red,
                                18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]

          //
        ],
      ),
    );
  }

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
//
  Widget status() {
    String statusText;

    if (!_isJoined) {
      statusText = 'Join a channel';
    } else if (_remoteUid == null) {
      statusText = 'Waiting for a remote user to join...';
    } else {
      statusText = 'Connected to remote user, uid:$_remoteUid';
    }

    return Text(
      statusText,
    );
  }

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

          strTotalMember.add('');
          if (kDebugMode) {
            print('=========>${strTotalMember.length}');
          }

          if (!mounted) return;
          setState(() {
            _isJoined = true;
          });

          if ('${strTotalMember.length}' == '1') {
            createAudioCallChannelViaXMPP('${connection.localUid}');
          }

          //
          //
          //
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          // showMessage("Remote user uid:$remoteUid joined the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid joined the channel");
          }
          if (!mounted) return;
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // showMessage("Remote user uid:$remoteUid left the channel");

          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }
          if (!mounted) return;
          setState(() {
            _remoteUid = null;
          });
          //
          if ('${strTotalMember.length}' == '1') {
            funcRemoveUserFromXMPP();
          }
          //
        },
      ),
    );
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
      channelId: strUUIDcreator, //channelName,
      options: options,
      uid: uid,
    );
  }

  // LEAVE
  void leave() {
    // dispose();
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel().then((value) => {
          //Navigator.pop(context)
          setState(() {
            strCallStatus = 'make_call';
          })
        });
  }

  // CLEAN RESOURCE
  // Clean up the resources when you leave
  @override
  void dispose() {
    // print('dispo');
    agoraEngine.leaveChannel();
    // dispose();
    super.dispose();
  }

  ///
  ///
  ///
  ///
  // create room id and then call
  // send message
  createAudioCallChannelViaXMPP(agoraId) {
    // print('dishant rajput 1');
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}call/audio/$strUUIDcreator',
    );

    users
        .add(
          {
            'channel_name': strUUIDcreator,
            'firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'name': strLoginUserName.toString(),
            'image': strLoginUserImage.toString(),
            'agora_id': agoraId.toString()
          },
        )
        .then(
          (value) => FirebaseFirestore.instance
              .collection("${strFirebaseMode}call")
              .doc('audio')
              .collection(strUUIDcreator)
              .doc(value.id)
              .set(
            {
              'firestore_id': value.id,
            },
            SetOptions(merge: true),
          ).then(
            (value1) {
              // print(value1),
            },
          ),

          //
          // print(''),

          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  funcRemoveUserFromXMPP() {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}call")
        .doc("audio")
        .collection(strUUIDcreator)
        .where("channel_name", isEqualTo: strUUIDcreator)
        .where("firebase_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }
        // ADD THIS USER TO FIREBASE SERVER
        // funcRegisterNewUserInDB();
        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            print(element.id.runtimeType);
          }

          // EDIT USER IF IT ALREADY EXIST
          FirebaseFirestore.instance
              .collection("${strFirebaseMode}call")
              .doc('audio')
              .collection(strUUIDcreator)
              .doc(element.id)
              .delete()
              .then((value) {
            if (kDebugMode) {
              print("Successfully removed this user from firebase!");
            }
            //

            //
          });

          ///
          ///
          ///
          ///
          ///
          ///
        }
        //
        Navigator.pop(context);
        //
      }
    });
  }

  // SEND NOTIFICATION
  funcSendNotificationToUsers(sendNotificationToUsersToken) async {
    if (kDebugMode) {
      print('NOTIFICATION PROCESS START');
      print(sendNotificationToUsersToken);
    }

    /* var serverKey = notificationServerKey;
    QuerySnapshot ref =
        await FirebaseFirestore.instance.collection('users').get();

    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Click to join',
            'title': 'Audio call from Simulator'
          },
          'priority': 'high',

          'data': <String, dynamic>{
            'name': strUUIDcreator,
            'channelName': '',
            'image': '',
            'message': '',
            'device': '',
            'deviceToken': '',
            'Receiver_device': '',
            'type': 'audioCall'
          },
          // 'type': 'audio_call',
          // 'data':
          'to': sendNotificationToUsersToken,
        },
      ),
    );*/
  }
}
*/