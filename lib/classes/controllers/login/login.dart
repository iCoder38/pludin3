import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pludin/classes/controllers/UI/designs/ui_BG.dart/ui_background.dart';
import 'package:pludin/classes/controllers/login/login_modal/login_modal.dart';
import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../database/database_helper.dart';
import '../database/database_modal.dart';

// import 'package:neopop/neopop.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  var strGoogleLoader = '0';
  var strSociallogin = '0';
  var strSocialEmail = '';
  late DataBase handler;
  //
  final signInApiCall = SignInModal();
  //
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  late final TextEditingController contEmail;
  late final TextEditingController contPassword;
  //
  final formKey = GlobalKey<FormState>();
  //
  @override
  void initState() {
    super.initState();

    //
    handler = DataBase();
    //
    contEmail = TextEditingController();
    contPassword = TextEditingController();

    /*FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }*/
    // handler.deletePlanet(1);
    // handler.deletePlanet(2);
    // if (value.isEmpty) {
    //   if (kDebugMode) {
    //     print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
    //   }
    // } else {
    //   if (kDebugMode) {
    //     print('YES, LOCAL DB HAVE SOME DATA');
    //   }
    // }
  }

  //
  @override
  void dispose() {
    //
    contEmail.dispose();
    contPassword.dispose();
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(
        navigationTitle: navigationTitleLogin,
        backClick: '0',
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.amber[600],
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    //
                    const BackgroundScreen(),
                    //
                    Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                          child: Container(
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
                                child: Image.asset(
                                  'assets/images/logo.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        const Spacer(),
                        //
                        Container(
                          // margin: const EdgeInsets.only(left: 10.0),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  color: Colors.white,
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffDDDDDD),
                                  //     blurRadius: 6.0,
                                  //     spreadRadius: 2.0,
                                  //     offset: Offset(0.0, 0.0),
                                  //   )
                                  // ],
                                ),
                                child: TextFormField(
                                  controller: contEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  readOnly: false,
                                  // controller: contGrindCategory,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.mail_outline_outlined,
                                      size: 24.0,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Email Address',
                                    contentPadding:
                                        EdgeInsets.only(top: 14, left: 20.0),
                                  ),
                                  onTap: () {
                                    // category_list_POPUP('str_message');
                                  },
                                  // validation
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              //
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  color: Colors.white,
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffDDDDDD),
                                  //     blurRadius: 6.0,
                                  //     spreadRadius: 2.0,
                                  //     offset: Offset(0.0, 0.0),
                                  //   )
                                  // ],
                                ),
                                child: TextFormField(
                                  controller: contPassword,
                                  readOnly: false,
                                  // controller: contGrindCategory,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.password,
                                      size: 24.0,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    contentPadding:
                                        EdgeInsets.only(top: 14, left: 20.0),
                                  ),
                                  onTap: () {
                                    // category_list_POPUP('str_message');
                                  },
                                  // validation
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              //
                              InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    //
                                    // Navigator.pushNamed(
                                    // context, 'push_to_home_screen');
                                    //

                                    //
                                    QuickAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      type: QuickAlertType.loading,
                                      title: 'Please wait...',
                                      text: 'loggin in...',
                                      onConfirmBtnTap: () {
                                        if (kDebugMode) {
                                          print('some click');
                                        }
                                        //
                                      },
                                    );
                                    //
                                    signInApiCall
                                        .signInWB(
                                      contEmail.text.toString(),
                                      contPassword.text.toString(),
                                    )
                                        .then((value) {
                                      if (kDebugMode) {
                                        print(value.allData);
                                      }
                                      //
                                      funcSaveAllLoginUserData(
                                          value.successStatus,
                                          value.message,
                                          value.allData);
                                      //
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ),
                                  ),
                                  child: Center(
                                    child: textWithBoldStyle(
                                      'Sign In',
                                      Colors.white,
                                      18.0,
                                    ),
                                  ),
                                  /*Center(
                                    child: textWithBoldStyle(
                                      'Sign In',
                                      Colors.white,
                                      18.0,
                                    ),
                                  ),*/
                                ),
                              ),
                              //
                              Row(
                                children: [
                                  /*Expanded(
                                    child: SignInWithAppleButton(
                                      onPressed: () async {
                                        final credential = await SignInWithApple
                                            .getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                        );

                                        print(credential);

                                        // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                        // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                      },
                                    ),
                                    /*Container(
                                      margin: const EdgeInsets.all(10.0),
                                      // color: Colors.pink,
                                      width: MediaQuery.of(context).size.width,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          75,
                                          136,
                                          237,
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
                                          'Facebook',
                                          Colors.white,
                                          18.0,
                                        ),
                                      ),
                                    ),*/
                                  ),*/
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        //
                                        FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        //
                                        final GoogleSignIn googleSignIn =
                                            GoogleSignIn();

                                        final GoogleSignInAccount?
                                            googleSignInAccount =
                                            await googleSignIn.signIn();

                                        if (googleSignInAccount != null) {
                                          final GoogleSignInAuthentication
                                              googleSignInAuthentication =
                                              await googleSignInAccount
                                                  .authentication;

                                          final AuthCredential credential =
                                              GoogleAuthProvider.credential(
                                            accessToken:
                                                googleSignInAuthentication
                                                    .accessToken,
                                            idToken: googleSignInAuthentication
                                                .idToken,
                                          );

                                          try {
                                            final UserCredential
                                                userCredential =
                                                await auth.signInWithCredential(
                                                    credential);

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
                                                strGoogleLoader = '0';
                                              });
                                            } else if (e.code ==
                                                'invalid-credential') {
                                              // ...
                                              setState(() {
                                                strGoogleLoader = '0';
                                              });
                                            }
                                          } catch (e) {
                                            // ...
                                            if (kDebugMode) {
                                              print(e);
                                            }
                                            setState(() {
                                              strGoogleLoader = '0';
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 54,
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
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
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
                                  child: SignInWithAppleButton(
                                    onPressed: () async {
                                      final credential = await SignInWithApple
                                          .getAppleIDCredential(
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
                                ),
                              ),
                              //
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      'push_to_forgot_password_screen');
                                },
                                child: textWithBoldStyle(
                                  'Forgot password ?',
                                  const Color.fromRGBO(
                                    230,
                                    223,
                                    74,
                                    1,
                                  ),
                                  16.0,
                                ),
                              ),
                              //
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'push_to_sign_up_screen');
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' - Sign Up',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            98,
                                            180,
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
                              const SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ),
                        //
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  loginViaApple(
    email,
    fullName,
    socialId,
    socialType,
  ) async {
    strSocialEmail = email.toString();
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
        strSociallogin = '1';
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

  loginViaGoogle(
    email,
    fullName,
    socialId,
    socialType,
  ) async {
    strSocialEmail = email.toString();
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
        strSociallogin = '1';
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
    print(strSociallogin);
    if (strSociallogin == '1') {
      Navigator.pushNamed(context, 'push_to_home_screen');
      // FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //         email: strSocialEmail.toString(), password: '12345678@')
      //     .then((value) => {
      //           //
      //           Navigator.pop(context),
      //           Navigator.pushNamed(context, 'push_to_home_screen'),
      //           //
      //         });
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: contEmail.text, password: '12345678@')
          .then((value) => {
                //
                Navigator.pop(context),
                Navigator.pushNamed(context, 'push_to_home_screen'),
                //
              });
    }
  }
  //
}
