// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:pludin/classes/header/utils.dart';

class NewVideoGetCallScreen extends StatefulWidget {
  const NewVideoGetCallScreen(
      {super.key, this.getFullDetailsOfThatDialog, required this.callStatus});
  final getFullDetailsOfThatDialog;
  final String callStatus;
  @override
  State<NewVideoGetCallScreen> createState() => _NewVideoGetCallScreenState();
}

class _NewVideoGetCallScreenState extends State<NewVideoGetCallScreen> {
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
                    setupVideoSDKEngine(),
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
              if (!mounted) return;
              setState(() {
                localCallStatus = '2';
              });
              //
              join();
              //
              //
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
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.amber,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blueGrey,
                    child: _remoteVideo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 80.0,
                          right: 20.0,
                        ),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: _localPreview(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 40.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              //
                              if (!mounted) return;
                              setState(() {
                                localCallStatus = '2';
                              });
                              //
                              leave();
                            },
                            child: Container(
                              height: 80,
                              width: 160,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  40.0,
                                ),
                              ),
                              child: Center(
                                child: textWithBoldStyle(
                                  'Decline',
                                  Colors.white,
                                  24.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //
  //
  //
  // Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(
        child: Text(
          '',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  //
  //
  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(
      RtcEngineContext(
        appId: appId,
      ),
    );

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (kDebugMode) {
            print("Local user uid:${connection.localUid} joined the channel");
          }
          if (!mounted) return;
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
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
          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }
          if (!mounted) return;
          setState(() {
            leave();
          });
        },
      ),
    );
  }

  //
  //
  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
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

// Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }
  //
}
