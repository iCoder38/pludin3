import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/database/database_helper.dart';
import '../header/utils.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen(
      {super.key, this.getAllData, required this.strGetCallStatus});

  final getAllData;
  final String strGetCallStatus;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  //
  //
  var strLoginUserId = '';
  var strLoginUserName = '';
  var strLoginUserImage = '';
  var strLoginUserFirebaseId = '';
  //
  late DataBase handler;
  var strCallStatus = '';
  var uuid = const Uuid().v4();
  var strUUIDcreator = '';
  var strCellsCountDesign = 1;
  static final _users = <int>[];
  //
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.getAllData);
      print(strUUIDcreator);
      print(widget.strGetCallStatus);
    }

    if (widget.strGetCallStatus == 'make_call') {
      // testing
      strUUIDcreator = '1234';

      ///
      ///
      ///
      // production
      // strUUIDcreator = uuid.toString();
      //
    } else {
      // testing
      strUUIDcreator = '1234';
      // print(widget.getAllData);
      ///
      ///
      ///
      // production
      // strUUIDcreator = widget.getAllData['channel_name'].toString();
    }
    if (kDebugMode) {
      print(strUUIDcreator);
    }
    //
    // strUUIDcreator = uuid.toString();
    //
    handler = DataBase();
    //
    super.initState();
    //
    funcGetLocalDBdata();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
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

// VIDEO CALL
  String channelName = "dishu-1234";
  String token = "";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: textWithRegularStyle(
          'Video Call',
          Colors.white,
          14.0,
        ),
        backgroundColor: navigationColor,
      ),
      body: Stack(
        children: [
          //
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: _localPreview()),
            ),
          ),
          //
          GridView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _users.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: strCellsCountDesign,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (kDebugMode) {
                print('======> TOTAL USERS IN  ARRAY<======');
                print(_users.length);
                print('====================================');
              }
              return Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _remoteVideo()),
              );
            },
          ),
          /*StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                    "${strFirebaseMode}call/video/$strUUIDcreator",
                  )
                  .where(
                    'channel_name',
                    isEqualTo: strUUIDcreator,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (kDebugMode) {
                    //
                    print('=====> TOTAL USERS IN VIDEO CHAT <====');
                    print(snapshot.data!.docs.length);
                    print('========> DESIGNS CELL COUNT <=========');
                    print(strCellsCountDesign);
                    if (snapshot.data!.docs.length == 1) {
                      strCellsCountDesign = 1;
                    } else if (snapshot.data!.docs.length == 2) {
                      strCellsCountDesign = 1;
                    } else {
                      strCellsCountDesign = 2;
                    }
                    print('=======================================');
                  }
                  //
                  return GridView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: strCellsCountDesign,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        // height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Center(child: _remoteVideo()),
                      );
                    },
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
              }),*/
          //
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
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
          ),
          //
        ],
      ),
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
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (kDebugMode) {
      print('=====> remote uid <=====');
      print(_remoteUid);
    }
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
  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(
      const RtcEngineContext(
        appId: 'bbe938fe04a746fd9019971106fa51ff',
      ),
    );

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
          //
          //
          //
          _users.add(_remoteUid!);
          //
          //
          // createAudioCallChannelViaXMPP('${connection.localUid}');
          //
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
            //
            _users.add(_remoteUid!);
            //
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
            _users.remove(_remoteUid!);
          });
        },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    //
    _users.clear();
    // funcRemoveUserFromXMPP();
    //
  }

// Release the resources when you leave
  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  //
  // XMPP(),
  // send message
  createAudioCallChannelViaXMPP(agoraId) {
    // print('dishant rajput 1');
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}call/video/$strUUIDcreator',
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
              .doc('video')
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

  //
  funcRemoveUserFromXMPP() {
    print(strUUIDcreator);

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}call")
        .doc("video")
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
              .doc('video')
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
  //
}
