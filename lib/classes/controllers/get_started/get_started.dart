// import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:pludin/classes/controllers/UI/designs/ui_BG.dart/ui_background.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../database/database_helper.dart';
import '../database/database_modal.dart';
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
  late DataBase handler;
  //
  @override
  void initState() {
    //
    handler = DataBase();
    super.initState();
  }

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
                        height: 0,
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
                            GestureDetector(
                              onTap: () async {
                                //
                                FirebaseAuth auth = FirebaseAuth.instance;
                                //
                                final GoogleSignIn googleSignIn =
                                    GoogleSignIn();

                                final GoogleSignInAccount? googleSignInAccount =
                                    await googleSignIn.signIn();

                                if (googleSignInAccount != null) {
                                  final GoogleSignInAuthentication
                                      googleSignInAuthentication =
                                      await googleSignInAccount.authentication;

                                  final AuthCredential credential =
                                      GoogleAuthProvider.credential(
                                    accessToken:
                                        googleSignInAuthentication.accessToken,
                                    idToken: googleSignInAuthentication.idToken,
                                  );

                                  try {
                                    final UserCredential userCredential =
                                        await auth
                                            .signInWithCredential(credential);

                                    if (kDebugMode) {
                                      print('============');
                                      print(userCredential);
                                      print('============');
                                    }
                                    loginViaGoogle(
                                      userCredential.user!.email,
                                      userCredential.user!.displayName,
                                      userCredential.user!.uid,
                                      'google',
                                    );

                                    // user = userCredential.user;
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code ==
                                        'account-exists-with-different-credential') {
                                      // ...
                                      setState(() {
                                        // strGoogleLoader = '0';
                                      });
                                    } else if (e.code == 'invalid-credential') {
                                      // ...
                                      setState(() {
                                        // strGoogleLoader = '0';
                                      });
                                    }
                                  } catch (e) {
                                    // ...
                                    if (kDebugMode) {
                                      print(e);
                                    }
                                    setState(() {
                                      // strGoogleLoader = '0';
                                    });
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(
                                    235,
                                    235,
                                    235,
                                    1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffDDDDDD),
                                  //     blurRadius: 6.0,
                                  //     spreadRadius: 2.0,
                                  //     offset: Offset(0.0, 0.0),
                                  //   )
                                  // ],
                                ),
                                child: Center(
                                  child: textWithBoldStyle(
                                    'Google',
                                    Colors.black,
                                    18.0,
                                  ),
                                ),
                              ),
                            ),
                            SignInWithAppleButton(
                              onPressed: () async {
                                final credential =
                                    await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                );

                                print(credential);
                                if (credential.email == null) {
                                  loginViaApple(
                                    '',
                                    '',
                                    credential.userIdentifier,
                                    'apple',
                                  );
                                } else {
                                  loginViaApple(
                                    credential.email,
                                    credential.familyName,
                                    credential.userIdentifier,
                                    'apple',
                                  );
                                }

                                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                              },
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
  loginViaApple(
    email,
    fullName,
    socialId,
    socialType,
  ) async {
    //strSocialEmail = email.toString();
    //
    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'action': 'socialLoginAction',
          'email': email.toString(),
          'fullName': fullName.toString(),
          'socialId': socialId.toString(),
          'socialType': socialType.toString(),
        },
      ),
    );

    // convert data to dict
    var data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(data);
    }

    if (resposne.statusCode == 200) {
      if (data['status'].toString().toLowerCase() == 'success') {
        //
        if (kDebugMode) {
          print('NOW SAVE LOCALLY');
        }
        // strSociallogin = '1';
        // Navigator.pop(context);
        funcSaveAllLoginUserData('success', 'done', data['data']);
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }

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

  loginViaGoogle(
    email,
    fullName,
    socialId,
    socialType,
  ) async {
    // strSocialEmail = email.toString();
    //
    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'action': 'socialLoginAction',
          'email': email.toString(),
          'fullName': fullName.toString(),
          'socialId': socialId.toString(),
          'socialType': socialType.toString(),
        },
      ),
    );

    // convert data to dict
    var data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(data);
    }

    if (resposne.statusCode == 200) {
      if (data['status'].toString().toLowerCase() == 'success') {
        //
        if (kDebugMode) {
          print('NOW SAVE LOCALLY');
        }
        // strSociallogin = '1';
        // Navigator.pop(context);
        funcSaveAllLoginUserData('success', 'done', data['data']);
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }

  funcSaveAllLoginUserData(
    status,
    message,
    data,
  ) {
    handler.retrievePlanets().then(
      (value) {
        if (kDebugMode) {
          print(value.length);
          print(data);
        }

        if (status == 'fails') {
          // fails
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: message.toString(),
          );
          //
        } else {
          // success
          if (kDebugMode) {
            print('successfully logged in');
          }
          // delete old local DB
          handler.deletePlanet(1);
          //
          List<Planets> loginUserDataForLocalDB = [];
          for (int i = 0; i < 1; i++) {
            Planets one = Planets(
              id: 1,
              userId: data['data']['userId'].toString(),
              fullName: data['data']['fullName'].toString(),
              lastName: data['data']['lastName'].toString(),
              middleName: data['data']['middleName'].toString(),
              email: data['data']['email'].toString(),
              gender: data['data']['gender'].toString(),
              contactNumber: data['data']['contactNumber'].toString(),
              role: data['data']['role'].toString(),
              dob: data['data']['dob'].toString(),
              address: data['data']['address'].toString(),
              zipCode: data['data']['zipCode'].toString(),
              city: data['data']['city'].toString(),
              state: data['data']['state'].toString(),
              status: data['data']['status'].toString(),
              image: data['data']['image'].toString(),
              device: data['data']['device'].toString(),
              deviceToken: data['data']['deviceToken'].toString(),
              socialId: data['data']['socialId'].toString(),
              socialType: data['data']['socialType'].toString(),
              latitude: data['data']['latitude'].toString(),
              longitude: data['data']['longitude'].toString(),
              firebaseId: data['data']['firebaseId'].toString(),
              username: data['data']['username'].toString(),
            );

            loginUserDataForLocalDB.add(one);
          }
          //
          // print('object 3333');
          if (kDebugMode) {
            print(loginUserDataForLocalDB);
          }
          handler.insertPlanets(loginUserDataForLocalDB);
          //
          // signin via firebase
          signInViaFirebase();
          //
        }
      },
    );
  }

  //
  signInViaFirebase() {
    Navigator.pushNamed(context, 'push_to_home_screen');
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
