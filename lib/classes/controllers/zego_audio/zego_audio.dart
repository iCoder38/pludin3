// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoAudioScreen extends StatefulWidget {
  const ZegoAudioScreen(
      {super.key, this.channelName, this.userIdIs, this.userName});

  final channelName;
  final userIdIs;
  final userName;

  @override
  State<ZegoAudioScreen> createState() => _ZegoAudioScreenState();
}

class _ZegoAudioScreenState extends State<ZegoAudioScreen> {
  //
  var strGetUserId = '0';
  late DataBase handler;
  //
  var uuid = const Uuid().v4();
  //
  @override
  void initState() {
    super.initState();
  }

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
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
        );
  }
}
