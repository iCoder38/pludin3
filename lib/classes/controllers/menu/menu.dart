import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/menu/menu_name/menu_name.dart';
import 'package:pludin/classes/header/utils.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        57,
        49,
        159,
        1,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          menuNavigationBarUI(context),
          //
          // const MenuNameScreen(),
          //
          Row(
            children: [
              Expanded(
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
                        'Dashbaord',
                        Colors.black,
                        18.0,
                      ),
                    ],
                  ),
                ),
              ),
              //
              Expanded(
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
              //
            ],
          ),
          //
          Row(
            children: [
              Expanded(
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
              //
              Expanded(
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
                        'Change Password',
                        Colors.black,
                        18.0,
                      ),
                    ],
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
                    Navigator.pushNamed(
                        context, 'push_to_search_friend_screen');
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
              //
            ],
          ),
          //
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'push_to_settings_screen');
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
              //
            ],
          ),
          //
        ],
      ),
    );
  }

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
}
