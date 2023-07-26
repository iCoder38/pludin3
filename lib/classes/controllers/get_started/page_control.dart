// ignore_for_file: non_constant_identifier_names

// import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
// import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pludin/classes/controllers/get_started/get_started.dart';
import 'package:pludin/classes/header/utils.dart';

class PageControlScreen extends StatefulWidget {
  const PageControlScreen({super.key});

  @override
  State<PageControlScreen> createState() => _PageControlScreenState();
}

class _PageControlScreenState extends State<PageControlScreen> {
  //
  final PageController controller = PageController();
  int _activePage = 0;
  //
  final pageCount = 5;
  //
  late int selectedPage;
  late final PageController _pageController;
  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(170, 0, 20, 1),
                Color.fromRGBO(180, 30, 20, 1),
                Color.fromRGBO(218, 115, 32, 1),
                Color.fromRGBO(227, 142, 36, 1),
                Color.fromRGBO(236, 170, 40, 1),
                Color.fromRGBO(248, 198, 40, 1),
                Color.fromRGBO(252, 209, 42, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 0,
          ),
          onPressed: () {
            // Navigator.pop(context, 'back');
          },
        ),
        backgroundColor: bg_color,
      ),*/
      body: PageView(
        /// [PageView.scrollDirection] defaults to [Axis.horizontal].
        /// Use [Axis.vertical] to scroll vertically.
        controller: controller,
        onPageChanged: (int page) {
          setState(() {
            _activePage = page;
            // print(_activePage);
          });
        },
        children: <Widget>[
          //
          page_control_ONE(context),
          page_control_TWO(context),
          page_control_THREE(context),
          page_control_FOUR(context),
          page_control_FIVE(context),
          //
        ],
      ),
    );
    /*Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            selectedPage = page;
          });
        },
        children: List.generate(pageCount, (index) {
          return page_control_ONE(context);
          /*PageView(
                  /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                  /// Use [Axis.vertical] to scroll vertically.
                  controller: controller,
                  onPageChanged: (int page) {
                    setState(() {
                      _activePage = page;
                      // print(_activePage);
                    });
                  },
                  children: <Widget>[
                    //
                    page_control_ONE(context),
                    page_control_TWO(context),
                    page_control_THREE(context),
                    page_control_FOUR(context),
                    page_control_FIVE(context),
                    //
                  ],
                );*/
          /*Container(
                  child: Center(
                    child: Text('Page $index'),
                  ),
                );*/
        }),
      ),
    );*/
    /**/
  }

  Stack page_control_ONE(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner1.png',
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.all(10.0),
            // color: Colors.transparent,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                56,
                50,
                146,
                0.8,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: textWithRegularStyle(
                    "Time doesn't take away from friendship, nor does separation.",
                    Colors.white,
                    18.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(112, 207, 214, 1),
                      // gradient: const LinearGradient(
                      //   colors: [
                      //     Color.fromRGBO(42, 200, 40, 1),
                      //     Color.fromRGBO(38, 192, 40, 1),
                      //     Color.fromRGBO(36, 186, 34, 1),
                      //     Color.fromRGBO(30, 174, 32, 1),
                      //     Color.fromRGBO(28, 160, 28, 1),
                      //     Color.fromRGBO(28, 150, 24, 1),
                      //   ],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Align(
                      child: textWithBoldStyle(
                        'Get Started Now',
                        Colors.white,
                        18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < 5; i++) ...[
                        if (i == 0) ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //TWO
  Stack page_control_TWO(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner2.png',
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.all(10.0),
            // color: Colors.transparent,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                56,
                50,
                146,
                0.8,
              ),
              /*gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.2,
                  0.5,
                  0.7,
                  0.6,
                ],
                colors: [
                  Color.fromARGB(218, 246, 54, 77),
                  Color.fromARGB(255, 238, 110, 110),
                  Color.fromARGB(233, 231, 126, 126),
                  Color.fromARGB(255, 244, 125, 125),
                ],
              ),*/
            ),
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: textWithRegularStyle(
                    "By chance we met, by choice we become friends.",
                    Colors.white,
                    18.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: const
                      color: const Color.fromRGBO(112, 207, 214, 1),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Align(
                      child: Text(
                        'Get Started Now'.tr,
                        style: TextStyle(
                          // fontFamily: font_family_name,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < 5; i++) ...[
                        if (i == 1) ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // THREE
  Stack page_control_THREE(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner3.png',
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.all(10.0),
            // color: Colors.transparent,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                56,
                50,
                146,
                0.8,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: textWithRegularStyle(
                    "A friend is someone with whom you dare to be yourself.",
                    Colors.white,
                    18.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(112, 207, 214, 1),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Align(
                      child: Text(
                        'Get Started Now'.tr,
                        style: TextStyle(
                          // fontFamily: font_family_name,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < 5; i++) ...[
                        if (i == 2) ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// FOUR
  Stack page_control_FOUR(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner4.png',
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.all(10.0),
            // color: Colors.transparent,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                56,
                50,
                146,
                0.8,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 240,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: textWithRegularStyle(
                    "What draws people to be friends is that they see the same truth. They share it.",
                    Colors.white,
                    18.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(112, 207, 214, 1),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Align(
                      child: Text(
                        'Get Started Now'.tr,
                        style: TextStyle(
                          // fontFamily: font_family_name,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < 5; i++) ...[
                        if (i == 3) ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // FIVE
  Stack page_control_FIVE(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner5.png',
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.all(10.0),
            // color: Colors.transparent,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                56,
                50,
                146,
                0.8,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 210,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: Text(
                    'Dating is a give and take. If you only see it as ‘taking,’ you are not getting it. ',
                    style: TextStyle(
                      // fontFamily: font_family_name,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(112, 207, 214, 1),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Align(
                      child: Text(
                        'Get Started Now'.tr,
                        style: TextStyle(
                          // fontFamily: font_family_name,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < 5; i++) ...[
                        if (i == 4) ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
