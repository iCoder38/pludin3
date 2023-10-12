import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoAudioScreen extends StatefulWidget {
  const ZegoAudioScreen({super.key});

  @override
  State<ZegoAudioScreen> createState() => _ZegoAudioScreenState();
}

class _ZegoAudioScreenState extends State<ZegoAudioScreen> {
  //
  var strGetUserId = '0';
  late DataBase handler;
  //
  @override
  void initState() {
    super.initState();

    handler = DataBase();

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
                    strGetUserId = value[i].userId.toString(),

                    // print(strLoginUserImage),
                    //
                  },
              });
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: 270372239,
        appSign:
            '1f22750d24a37c0ea5ba884e2409de12d216e222adfd17dafee55175b1f85f30',
        userID: '2',
        userName: 'Dishant Rajput',
        callID: 'dishu_1234',
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        // ..onOnlySelfInRoom = () => Navigator.of(context).pop(),
        );
  }
}
