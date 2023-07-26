import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/UI/designs/splash_bg/splash_bg.dart';
import 'package:pludin/classes/controllers/UI/designs/splash_mid_logo/splash_center_logo.dart';
import 'package:pludin/classes/controllers/chat_audio_call/chat_audio_call.dart';
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
          print(
              'Message also contained a notification: ${message.notification}');
        }
        // setState(() {
        //   notifTitle = message.notification!.title;
        //   notifBody = message.notification!.body;
        // });
      }
      //
      if (message.data['type'].toString() == 'audio_call') {
        //
        if (kDebugMode) {
          print(message.data['channel_name'].toString());
        }
        //
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatAudioCallScreen(
              getAllData: message.data,
              strGetCallStatus: 'get_call',
            ),
          ),
        );
        //
      } else if (message.data['type'].toString() == 'videoCall') {
        //
      }
    });
  }

  funcClickOnNotification() {
// FirebaseMessaging.configure

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (kDebugMode) {
        print('=====> CLICK NOTIFICATIONs <=====');
        print(remoteMessage.data);
      }

      if (remoteMessage.data['type'].toString() == 'audio_call') {
        //
        print('user click on notification');
      } else if (remoteMessage.data['type'].toString() == 'videoCall') {
        //
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
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
