// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:pludin/classes/header/utils.dart';

class NewAudioGetCallScreen extends StatefulWidget {
  const NewAudioGetCallScreen(
      {super.key, this.getFullDetailsOfThatDialog, required this.callStatus});
  final getFullDetailsOfThatDialog;
  final String callStatus;
  @override
  State<NewAudioGetCallScreen> createState() => _NewAudioGetCallScreenState();
}

class _NewAudioGetCallScreenState extends State<NewAudioGetCallScreen> {
  //
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
  @override
  void initState() {
    //
    handler = DataBase();
    //
    if (kDebugMode) {
      print('=============================================');
      print('=========== IN AUDIO CALL SCREEN ============');
      print(widget.getFullDetailsOfThatDialog);
      print(widget.callStatus);
      print('=============================================');
      print('=============================================');
    }

    funcGetLocalDBdata();

    super.initState();
  }

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
                    // funcRefreshScreenAndInitAgora(),
                    setupVoiceSDKEngine(),
                    funcGetCallManage(),
                    //
                  },
              });
        }
      },
    );
    //
  }

  funcGetCallManage() {
    channelName = widget.getFullDetailsOfThatDialog['channelName'].toString();

    if (kDebugMode) {
      print('=============================================');
      print('============= channel name =====================');
      print(channelName);
      print('=============================================');
      print('=============================================');
    }

    //
    final values =
        widget.getFullDetailsOfThatDialog['channelName'].toString().split('+');
    if (kDebugMode) {
      print(values);
    }
    //
    //
    if (kDebugMode) {
      print('Login user FID');
      print(FirebaseAuth.instance.currentUser!.uid);
      print(strLoginUserFirebaseId);
      print('Login user FID');
    }

    for (int i = 0; i < values.length; i++) {
      if (values[i].toString() == FirebaseAuth.instance.currentUser!.uid) {
        if (kDebugMode) {
          print('YES, MATCHED');
          print(i);
          print('YES, MATCHED');
        }
      } else {
        if (kDebugMode) {
          print('NOT, MATCHED');
          print(values[i]);
          print('NOT, MATCHED');
        }
        //
        FirebaseFirestore.instance
            .collection("${strFirebaseMode}member")
            .doc("India")
            .collection("details")
            .where("firebaseId", isEqualTo: values[i].toString())
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
          } else {
            for (var element in value.docs) {
              if (kDebugMode) {
                print('======> YES,  USER FOUND');
                print(element.data()['name'].toString());
              }
              //
              strOtherUserName = element.data()['name'].toString();
              strOtherUserImage = element.data()['image'].toString();
              /*if (!mounted) return;
              setState(() {
                localCallStatus = '2';
              });
              //
              join();*/
              //
              //
              setState(() {});
            }
          }
        });
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
          // show both button
          acceptDeclineUI(context)
        ] else if (localCallStatus == '2') ...[
          // phone accept, show only decline
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  //
                  GestureDetector(
                    onTap: () {
                      //
                      if (!mounted) return;
                      setState(() {
                        localCallStatus = '3';
                      });
                      //
                      leave();
                      //
                    },
                    child: Container(
                      height: 80,
                      width: 140,
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
                          'Decline',
                          Colors.white,
                          18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]

        //
      ],
    ));
  }

  Expanded acceptDeclineUI(BuildContext context) {
    return Expanded(
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
                  localCallStatus = '2';
                });
                //
                join();

                //
                // funcGetDeviceTokenFromXMPP();
                //
              },
              child: Container(
                height: 80,
                width: 140,
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
                    'Accept',
                    Colors.white,
                    18.0,
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              width: 10,
            ),
            //
            GestureDetector(
              onTap: () {
                //
                setState(() {
                  localCallStatus = '3';
                });
                //
                // join();

                //
                // funcGetDeviceTokenFromXMPP();
                //
              },
              child: Container(
                height: 80,
                width: 140,
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
                    'Decline',
                    Colors.white,
                    18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
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

          /*if (!mounted) return;
          setState(() {
            _remoteUid = null;
          });*/
          //
        },
      ),
    );
  }

  //
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
    // .then((value) => {
    //       //
    //       if (localCallStatus == '3')
    //         {
    //           print(' ================================='),
    //           print(' ================================='),
    //           print(' =====> user decline incoming call'),
    //           agoraEngine.leaveChannel().then((value) => {
    //                 setState(() {
    //                   localCallStatus = '0';
    //                   Navigator.pop(context);
    //                 }),
    //               })
    //         }
    //     });
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
