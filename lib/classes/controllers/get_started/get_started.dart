// import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:pludin/classes/controllers/UI/designs/ui_BG.dart/ui_background.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:pludin/classes/controllers/UI/designs/splash_bg/splash_bg.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class MyItem {
  String itemName;
  String path;
  MyItem(this.itemName, this.path);
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  //
  int activeIndex = 0;
  List<MyItem> items = [
    MyItem("1/5",
        'I would rather walk with a friend in the dark, than alone in the light.'),
    MyItem("2/5",
        'True friends are never apart, maybe in distance but never in heart.'),
    MyItem("3/5",
        'Life is partly what we make it, and partly what it is made by the friends we choose.'),
    MyItem("4/5",
        'Real friendship, like real poetry, is extremely rare — and precious as a pearl.'),
    MyItem("5/5", 'True love is finding your soul mate in your best friend.'),
  ];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          navigationTitleGetStarted,
          Colors.white,
          18.0,
        ),
        backgroundColor: navigationColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  //
                  const BackgroundScreen(),
                  //
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        // height: 48.0,
                        // child: widget
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            // child: widget
                            /*
                            Image.asset(
                          'assets/images/logo.png',
                        ), */
                            child: Image.asset(
                              'assets/images/logo.png',
                            ),
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 60,
                      ),
                      //
                      textWithBoldStyle(
                        'Love Quote',
                        Colors.white,
                        30.0,
                      ),
                      //
                      const SizedBox(
                        height: 30,
                      ),
                      //
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              // height: 160,
                              margin: const EdgeInsets.only(
                                right: 30,
                                left: 30.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: Center(
                                child: CarouselSlider.builder(
                                  itemCount: items.length,
                                  options: CarouselOptions(
                                    height: 140,
                                    viewportFraction: 1,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                    autoPlayInterval:
                                        const Duration(seconds: 1),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        activeIndex = index;
                                      });
                                    },
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    final imgList = items[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: buildImage(
                                              imgList.path,
                                              index,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 34,
                                        ),

                                        // buildText(imgList.itemName, index),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            //
                            buildIndicator(),
                            //
                          ],
                        ),
                      ),

                      //
                      const SizedBox(
                        height: 40,
                      ),
                      //
                      // Spacer(),
                      //
                      Container(
                        // margin: const EdgeInsets.all(10.0),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(
                                  75,
                                  136,
                                  237,
                                  1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  35.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 14.0,
                                      ),
                                      width: 48,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          25,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/facebook.png',
                                      ),
                                    ),
                                  ),
                                  //
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Align(
                                    child: textWithBoldStyle(
                                      'Login with Facebook',
                                      Colors.white,
                                      18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //
                            const SizedBox(
                              height: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                // print('object');
                                Navigator.pushNamed(
                                  context,
                                  'push_to_login_screen',
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(
                                    222,
                                    54,
                                    71,
                                    1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    35.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 14.0,
                                      ),
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          25,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/email2.png',
                                      ),
                                    ),
                                    //
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Align(
                                      child: textWithBoldStyle(
                                        'Login with Email',
                                        Colors.white,
                                        18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //
                            const SizedBox(
                              height: 10,
                            ),
                            //
                            GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print('sign up click');
                                }
                                //
                                Navigator.pushNamed(
                                    context, 'push_to_sign_up_screen');
                                //
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: "Don't have an account ? - ",
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 18.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                          98,
                                          179,
                                          188,
                                          1,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //

  //
  Card buildButton({
    required onTap,
    required title,
    required text,
    required leadingImage,
  }) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: AssetImage(
            leadingImage,
          ),
        ),
        title: Text(title ?? ""),
        subtitle: Text(text ?? ""),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
        ),
      ),
    );
  }

  Widget buildImage(String imgList, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: textWithBoldStyle(
            imgList.toString(),
            Colors.white,
            18.0,
          ),
          /*Image.asset(
            imgList,
            fit: BoxFit.cover,
          ),*/
        ),
      );

  buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: items.length,
        effect: const JumpingDotEffect(
          dotColor: Colors.black,
          dotHeight: 12,
          dotWidth: 12,
          activeDotColor: Color.fromRGBO(
            112,
            208,
            214,
            1,
          ),
        ),
      );

  buildText(String itemName, int index) => Align(
      alignment: FractionalOffset.bottomCenter,
      child: Text(
        itemName,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 23,
          color: Colors.white,
        ),
      ));
}
