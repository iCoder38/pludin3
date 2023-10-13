// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/chat_video_call/new_video_call/new_video_get_call/new_video_get_call.dart';
import 'package:pludin/classes/controllers/UI/designs/splash_bg/splash_bg.dart';
import 'package:pludin/classes/controllers/UI/designs/splash_mid_logo/splash_center_logo.dart';
import 'package:pludin/classes/controllers/chat_audio_call/chat_audio_call.dart';
import 'package:pludin/classes/controllers/chat_audio_call/new_audio_call/new_audio_call.dart';
import 'package:pludin/classes/controllers/chat_audio_call/new_audio_get_call/new_audio_get_call.dart';
import 'package:pludin/classes/controllers/zego_audio/zego_audio.dart';
import 'package:pludin/classes/controllers/zego_video/zego_video.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/database/database_helper.dart';
// import 'package:pludin/classes/splash/header/utils.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:geolocator/geolocator.dart';

import '../controllers/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  RemoteMessage? initialMessage;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //
  String? notifTitle, notifBody;
  //
  late DataBase handler;
  //
  Timer? timer;
  //
  var strLoginUserId = '0';
  var strLoginFirebaseId = '0';
  //
  @override
  void initState() {
    super.initState();

    // funcSignInDummyAccount();
    //

    funcGetAllNotificationFunctions();
    //
    handler = DataBase();
    //
    // handler.deletePlanet(1).then((value) => {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const LoginScreen(),
    //           ),
    //           (Route<dynamic> route) => false),
    //     });
    //
    funPermissionForLatLong();
    //
    handler.retrievePlanets().then(
      (value) {
        if (kDebugMode) {
          print(value.length);
        }
        if (value.isEmpty) {
          if (kDebugMode) {
            print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
          }
          //
          funcPlayTimer();
          //
        } else {
          if (kDebugMode) {
            print('YES, LOCAL DB HAVE SOME DATA');
          }

          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    strLoginUserId = value[i].fullName.toString(),
                    strLoginFirebaseId = value[i].firebaseId.toString(),

                    //
                  },
              });

          // push to home screen
          Navigator.pushNamed(context, 'push_to_home_screen');
          //
        }
      },
    );
  }

  // permission
  funPermissionForLatLong() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('Location permissions are denied');
        }
      } else if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print("'Location permissions are permanently denied");
        }
      } else {
        if (kDebugMode) {
          print("GPS Location service is granted");
        }
      }
    } else {
      if (kDebugMode) {
        print("GPS Location permission granted.");
      }
    }
  }

  funcGetAllNotificationFunctions() {
    funcGetDeviceToken();
    //
    funcGetFullDataOfNotification();
    //
    funcClickOnNotification();
    //
  }

  //
  funcGetDeviceToken() async {
    //
    final token = await firebaseMessaging.getToken();

    //
    if (kDebugMode) {
      print('=============> HERE IS MY DEVICE TOKEN <=============');
      print('======================================================');
      print(token);
      print('======================================================');
      print('======================================================');
    }
    // save token locally
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('deviceToken', token.toString());
    //
  }

  // get notification in foreground
  funcGetFullDataOfNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('=====> GOT NOTIFICATION IN FOREGROUND <=====');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message data: ${message.data}');
          print('${message.data['userId']}');
        }
      }

      if (message.data['type'].toString() == 'audioCall') {
        ///
        callAcceptOrDecline(
          context,
          message.data['name'].toString(),
          message.data['channelName'].toString(),
        );

        ///
      } else if (message.data['type'].toString() == 'videoCall') {
        ///
        callAcceptOrDeclineVideoCall(
          context,
          message.data['name'].toString(),
          message.data['channelName'].toString(),
        );

        ///
      } else if (message.data['type'].toString() == 'groupVoiceCall') {
        ///
        acceptDeclineGroupVoiceCall(
          context,
          message.data['name'].toString(),
          message.data['channelName'].toString(),
        );

        ///
      }
    });
  }

//
  void callAcceptOrDecline(
    BuildContext context,
    String call_from,
    String channel_name,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithBoldStyle(
                      //
                      'Incoming Audio Call From $call_from',
                      //
                      Colors.black,
                      16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      //
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZegoAudioScreen(
                            userIdIs: strLoginFirebaseId.toString(),
                            channelName: channel_name.toString(),
                            userName: strLoginUserId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Center(
                        child: textWithBoldStyle(
                          'Accept',
                          Colors.green,
                          16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Center(
                      child: textWithBoldStyle(
                        'Decline',
                        Colors.redAccent,
                        14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//
  void callAcceptOrDeclineVideoCall(
    BuildContext context,
    String call_from,
    String channel_name,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithBoldStyle(
                      //
                      'Incoming Video Call From $call_from',
                      //
                      Colors.black,
                      16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      //
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZegoVideoScreen(
                            userIdIs: strLoginFirebaseId.toString(),
                            channelName: channel_name.toString(),
                            userName: strLoginUserId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Center(
                        child: textWithBoldStyle(
                          'Accept',
                          Colors.green,
                          16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Center(
                      child: textWithBoldStyle(
                        'Decline',
                        Colors.redAccent,
                        14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//
  void acceptDeclineGroupVoiceCall(
    BuildContext context,
    String call_from,
    String channel_name,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithBoldStyle(
                      //
                      'Incoming Group Audio Call From $call_from',
                      //
                      Colors.black,
                      16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      //
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZegoVideoScreen(
                            userIdIs: strLoginFirebaseId.toString(),
                            channelName: channel_name.toString(),
                            userName: strLoginUserId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Center(
                        child: textWithBoldStyle(
                          'Accept',
                          Colors.green,
                          16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Center(
                      child: textWithBoldStyle(
                        'Decline',
                        Colors.redAccent,
                        14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  funcClickOnNotification() {
// FirebaseMessaging.configure

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (kDebugMode) {
        print('=====> CLICK NOTIFICATIONs <=====');
        print(remoteMessage.data);
      }

      if (remoteMessage.data['type'].toString() == 'audioCall') {
        //
        callAcceptOrDecline(
          context,
          remoteMessage.data['name'].toString(),
          remoteMessage.data['channelName'].toString(),
        );
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewAudioGetCallScreen(
              getFullDetailsOfThatDialog: remoteMessage.data,
              callStatus: 'get_call',
            ),
          ),
        );*/
      } else if (remoteMessage.data['type'].toString() == 'videoCall') {
        //
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewVideoGetCallScreen(
              getFullDetailsOfThatDialog: remoteMessage.data,
              callStatus: 'get_call',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          //
          SplashBackground(),
          //
          SplashCenterLogo()
          //
        ],
      ),
    );
  }

  //
  funcPlayTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        //
        if (t.tick == 2) {
          t.cancel();
          // func_push_to_next_screen();
          if (kDebugMode) {
            print('object');
          }
          //
          Navigator.pushNamed(context, 'push_to_page_control');
          //
        }
      },
    );
  }

  //
  funcRememberMe() {}
}
