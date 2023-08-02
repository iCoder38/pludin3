// ignore_for_file: prefer_final_fields, prefer_typing_uninitialized_variables, unused_element
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:pludin/classes/header/utils.dart';

class NewVideoCallScreen extends StatefulWidget {
  const NewVideoCallScreen(
      {super.key, this.getFullDetailsOfThatDialog, required this.callStatus});

  final getFullDetailsOfThatDialog;
  final String callStatus;

  @override
  State<NewVideoCallScreen> createState() => _NewVideoCallScreenState();
}

class _NewVideoCallScreenState extends State<NewVideoCallScreen> {
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
  String channelName = '12345';
  String token = '';
  int uid = 0;
  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;
  //
  @override
  void initState() {
    //
    handler = DataBase();
    //
    if (kDebugMode) {
      print('=============================================');
      print('=========== IN VIDEO CALL SCREEN ============');
      print(widget.getFullDetailsOfThatDialog);
      print(widget.callStatus);
      print('=============================================');
      print('=============================================');
    }
    //
    channelName =
        '${widget.getFullDetailsOfThatDialog['sender_firebase_id'].toString()}+${widget.getFullDetailsOfThatDialog['receiver_firebase_id'].toString()}';
    //
    funcGetLocalDBdata();
    //
    //
    if (widget.callStatus == 'make_call') {
      localCallStatus = '1';
    } else {}
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
  //
  //
  funcRefreshScreenAndInitAgora() {
    // init agora first
    setupVideoSDKEngine();
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
        /*appBar: AppBar(
          title: const Text(
            'Video',
          ),
        ),*/
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
                  color: Colors.grey[200],
                  child: (localCallStatus == '2')
                      ? Center(
                          child: textWithRegularStyle(
                            'calling... ( $strOtherUserName )',
                            Colors.black,
                            14.0,
                          ),
                        )
                      : Center(
                          child: textWithRegularStyle(
                            'Press call to call ( $strOtherUserName )',
                            Colors.black,
                            14.0,
                          ),
                        ),
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
                      child: (localCallStatus == '2')
                          ? _localPreview()
                          : const SizedBox(),
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
                      child: (localCallStatus == '1')
                          ? Center(
                              child: GestureDetector(
                                onTap: () {
                                  //
                                  if (!mounted) return;
                                  setState(() {
                                    localCallStatus = '2';
                                  });
                                  //
                                  funcGetDeviceTokenFromXMPP();
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(
                                      40.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: textWithBoldStyle(
                                      'Call',
                                      Colors.white,
                                      24.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  //
                                  if (!mounted) return;
                                  setState(() {
                                    localCallStatus = '1';
                                  });
                                  //
                                  leave();
                                  //
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
    )

        /*ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          // Container for the local video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _localPreview()),
          ),
          const SizedBox(height: 10),
          //Container for the Remote video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _remoteVideo()),
          ),
          // Button Row
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? null : () => {join()},
                  child: const Text("Join"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? () => {leave()} : null,
                  child: const Text("Leave"),
                ),
              ),
            ],
          ),
          // Button Row ends
        ],
      ),*/
        );
  }

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
  funcGetDeviceTokenFromXMPP() {
    //
    // showLoadingUI(context, 'please wait...');
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
          'message': 'Incoming Video Call',
          'userId': strLoginUserFirebaseId.toString(),
          'name': strLoginUserName.toString(),
          'image': strLoginUserImage.toString(),
          'deviceJson': encoded,
          'type': 'videocall',
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
}
