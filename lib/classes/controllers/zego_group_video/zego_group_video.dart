// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZeroGroupVideoScreen extends StatefulWidget {
  const ZeroGroupVideoScreen(
      {super.key, this.channelName, this.userIdIs, this.userName});

  final channelName;
  final userIdIs;
  final userName;

  @override
  State<ZeroGroupVideoScreen> createState() => _ZeroGroupVideoScreenState();
}

class _ZeroGroupVideoScreenState extends State<ZeroGroupVideoScreen> {
  //
  var strGetUserId = '0';
  //
  var uuid = const Uuid().v4();
  //
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: 270372239,
        appSign:
            '1f22750d24a37c0ea5ba884e2409de12d216e222adfd17dafee55175b1f85f30',
        userID: widget.userIdIs.toString(),
        userName: widget.userName.toString(),
        callID: widget.channelName.toString(),
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
        // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
        );
  }
}
