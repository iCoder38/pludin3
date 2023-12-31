// // ignore_for_file: avoid_function_literals_in_foreach_calls

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:pludin/classes/header/utils.dart';
// // import '../utils/AppID.dart';
// // import 'package:agora_rtc_engine/rtc_engine.dart';
// // import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// // import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

// class CallPage extends StatefulWidget {
//   final String channelName;

//   const CallPage({required Key key, required this.channelName})
//       : super(key: key);

//   @override
//   _CallPageState createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   late RtcEngine _engine;
//   String token = "";
//   //
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     _engine.leaveChannel();

//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }

//   Future<void> initialize() async {
//     if (appId.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     // await _engine.enableWebSdkInteroperability(true);

//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     );

//     await _engine.joinChannel(
//       token: token,
//       channelId: '',
//       options: options,
//       uid: 0,
//     );
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     // _engine = await RtcEngine.create(appId);
//     await _engine.enableVideo();
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     /*_engine.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         setState(() {
//           final info = 'onError: $code';
//           _infoStrings.add(info);
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           final info = 'onJoinChannel: $channel, uid: $uid';
//           _infoStrings.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           _infoStrings.add('onLeaveChannel');
//           _users.clear();
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           final info = 'userJoined: $uid';
//           _infoStrings.add(info);
//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         setState(() {
//           final info = 'userOffline: $uid , reason: $reason';
//           _infoStrings.add(info);
//           _users.remove(uid);
//         });
//       },
//       firstRemoteVideoFrame: (uid, width, height, elapsed) {
//         setState(() {
//           final info = 'firstRemoteVideoFrame: $uid';
//           _infoStrings.add(info);
//         });
//       },
//     ));*/

//     // Register the event handler
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() {
//             final info = 'onJoinChannel: ${connection.localUid}';
//             _infoStrings.add(info);
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           // showMessage("Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             final info = 'userJoined: $remoteUid';
//             _infoStrings.add(info);
//             _users.add(remoteUid);
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           // showMessage("Remote user uid:$remoteUid left the channel");
//           setState(() {
//             final info = 'userOffline: $remoteUid , reason: $reason';
//             _infoStrings.add(info);
//             _users.remove(remoteUid);
//           });
//         },
//         onFirstRemoteVideoFrame:
//             (connection, remoteUid, width, height, elapsed) {
//           setState(() {
//             final info = 'firstRemoteVideoFrame: $remoteUid';
//             _infoStrings.add(info);
//           });
//         },
//       ),
//     );
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Agora Group Video Calling'),
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _viewRows(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     list.add(RtcLocalView.SurfaceView());
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }
// }
