// ignore_for_file: camel_case_types, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/change_password/change_password.dart';
// import 'package:pludin/classes/controllers/chat/chat.dart';
import 'package:pludin/classes/controllers/chat_dialog/chat_dialog.dart';
import 'package:pludin/classes/controllers/home/home.dart';
import 'package:pludin/classes/controllers/login/login.dart';
import 'package:pludin/classes/controllers/menu/menu_name/menu_name.dart';
import 'package:pludin/classes/controllers/my_friends/my_friends.dart';
import 'package:pludin/classes/controllers/search_friends/search_friends.dart';
import 'package:pludin/classes/controllers/settings/settings.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:pludin/classes/help/help.dart';
import 'package:pludin/classes/home_new/home_new.dart';
import 'package:pludin/classes/notification/notification.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../database/database_helper.dart';
// import 'package:journey_recorded/Utils.dart';
// import 'package:journey_recorded/dashboard/dashboard.dart';
// import 'package:journey_recorded/edit_profile/edit_profile.dart';
// import 'package:journey_recorded/login/login.dart';
// import 'package:journey_recorded/splash/splash_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawer extends StatefulWidget {
  const navigationDrawer({Key? key}) : super(key: key);

  @override
  State<navigationDrawer> createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {
  //
  late DataBase handler;
  //
  var strLoginProfileName = '';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserTagName = '';
  var strLoginUserimage = '';
  //
  @override
  void initState() {
    super.initState();
    //
    if (kDebugMode) {
      print('init called ?');
    }
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
    funcGetLocalDBdata();
    //
  }

  //
  funcGetLocalDBdata() async {
    await handler.retrievePlanets().then(
      (value) {
        if (kDebugMode) {
          print(value);
          print(value.length);
        }
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
                    strLoginProfileName = value[i].fullName.toString(),
                    strLoginUserId = value[i].userId.toString(),
                    strLoginUserName = value[i].username.toString(),
                    strLoginUserimage = value[i].image.toString(),
                    setState(() {
                      if (kDebugMode) {
                        print('=====> LOGIN USERDATA IN MENU <=====');
                        print(strLoginProfileName);
                        print(strLoginUserId);
                        print(strLoginUserName);
                      }
                    }),
                  }
                //

                //
              });
          // setState(() {
          //   if (kDebugMode) {
          //     print('me');
          //   }
          // });
          //
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(
        57,
        49,
        159,
        1,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          menuNavigationBarUI(context),
          //
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    //
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyProfileScreen(
                    //       strUserId: widget.strloginUserId,
                    //     ),
                    //   ),
                    // );
                    //
                  },
                  child: (strLoginUserimage == '')
                      ? Container(
                          margin: const EdgeInsets.only(left: 0.0),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/logo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.pink[600],
                            borderRadius: BorderRadius.circular(
                              27.0,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 0.0),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.pink[600],
                            borderRadius: BorderRadius.circular(
                              27.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              27,
                            ),
                            child: Image.network(
                              strLoginUserimage,
                              width: 27,
                              height: 27,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                //
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: textWithBoldStyle(
                            //
                            strLoginProfileName.toString(),
                            //
                            Colors.white,
                            18.0,
                          ),
                        ),
                      ),
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithRegularStyle(
                          //
                          ' @$strLoginUserName',
                          //
                          const Color.fromRGBO(
                            112,
                            209,
                            214,
                            1,
                          ),
                          14.0,
                        ),
                      ),
                      //
                    ],
                  ),
                ),
                //
                IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('click cross');
                    }
                    //
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // MenuNameScreen(
          //   strloginUserName: strLoginUserName.toString(),
          //   strloginUserId: strLoginUserId.toString(),
          //   strloginProfileName: strLoginProfileName.toString(),
          // ),
          //
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeNewScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_dashboard.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Dashboard',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyFriendsScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_review.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Friends',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
            ],
          ),
          //
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DialogScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_chat.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Chat',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Help',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
            ],
          ),
          //
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchFriendsScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_friends.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Search Friends',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_notification.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Notification',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
            ],
          ),
          //
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    //
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ),
                    );
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_settings.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Settings',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Logout alert
                    QuickAlert.show(
                      context: context,
                      barrierColor: Colors.blueGrey,
                      type: QuickAlertType.confirm,
                      text: 'Do you want to logout',
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: Colors.green,
                      onConfirmBtnTap: () {
                        if (kDebugMode) {
                          print('some click');
                        }
                        //
                        logoutWB();

                        //
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),

                    // width: 48.0,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            'assets/icons/menu_logout.png',
                          ),
                        ),
                        textWithBoldStyle(
                          'Logout',
                          Colors.black,
                          18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
            ],
          ),
          //
        ],
      ),
    );
  }

  //
  logoutWB() async {
    if (kDebugMode) {
      // print('=====> POST : COMMENTS LIST');
    }

    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'logging out...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'logout',
          'userId': strLoginUserId.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
//
        Navigator.pop(context);
        Navigator.pop(context);
        //
        FirebaseAuth.instance.signOut();
        //
        // delete old local DB
        handler.deletePlanet(1).then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (Route<dynamic> route) => false),
            });
        //
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  Container menuNavigationBarUI(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0),
      color: navigationColor,
      width: MediaQuery.of(context).size.width,
      height: 88,
      // child: widget
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: textWithBoldStyle(
                  'Menu',
                  Colors.white,
                  20.0,
                ),
              ),
            ),
          ),
          //
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('menu click');
                }

                //
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
                //
              },
              icon: const Icon(
                Icons.notifications_sharp,
                color: Colors.white,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }
  //
}
