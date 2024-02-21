// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_return_type_for_catch_error

import 'dart:io';

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:pludin/classes/controllers/UI/designs/ui_BG.dart/ui_background.dart';
import 'package:pludin/classes/controllers/sign_up/sign_up_modal.dart/sign_up_modal.dart';
import 'package:pludin/classes/controllers/sign_up/verify_modal/verify_modal.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  late final TextEditingController contUserName;
  late final TextEditingController contName;
  late final TextEditingController contEmail;
  late final TextEditingController contPhone;
  late final TextEditingController contPassword;
  late final TextEditingController contConfirmPassword;
  //

  //
  var strUsernameVerified = '0';
  //
  final verifyApiCall = VerifyModal();
  final signApiCall = SignUpModal();
  //
  final formKey = GlobalKey<FormState>();
  //
  var strImage = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  @override
  void initState() {
    super.initState();

    contUserName = TextEditingController();
    contName = TextEditingController();
    contEmail = TextEditingController();
    contPhone = TextEditingController();
    contPassword = TextEditingController();
    contConfirmPassword = TextEditingController();

    //

    //
  }

  @override
  void dispose() {
    contUserName.dispose();
    contName.dispose();
    contEmail.dispose();
    contPhone.dispose();
    contPassword.dispose();
    contConfirmPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Create an account',
          Colors.white,
          20.0,
        ),
        backgroundColor: navigationColor,
        actions: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('object');
              }
              //
              openCameraAndGalleryPopUP(context);
              //
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          //
          const BackgroundScreen(),
          //
          Container(
            // margin: const EdgeInsets.all(10.0),
            color: navigationColor,
            width: MediaQuery.of(context).size.width,
            height: 160,
            // child: widget
          ),
          //
          Container(
            margin: const EdgeInsets.only(
              top: 80.0,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 140,
            child: Center(
              child: (strImage == '0')
                  ? Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/sign_up_image_border.png',
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.blue,
                        width: 10,
                      )
                          // image: DecorationImage(
                          //   image: Image.network('src'),
                          //   fit: BoxFit.fitHeight,
                          // ),
                          ),
                      child: Image.file(
                        fit: BoxFit.cover,
                        imageFile!,
                      ),
                    ),
            ),
          ),
          //
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 240.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        //
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  readOnly: false,
                                  controller: contUserName,
                                  decoration: const InputDecoration(
                                    // suffix: ,
                                    // suffixIcon:
                                    border: InputBorder.none,
                                    hintText: 'Username',
                                    contentPadding: EdgeInsets.only(left: 20.0),
                                  ),
                                  onTap: () {
                                    // category_list_POPUP('str_message');
                                  },
                                  // validation
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter username';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            //
                            InkWell(
                              onTap: () {
                                setState(() {
                                  strUsernameVerified = '1';
                                });
                                //
                                verifyApiCall
                                    .verifyWB(contUserName.text)
                                    .then((value) => {
                                          print(value.successStatus),
                                          if (value.message ==
                                              'Username available.')
                                            {
                                              //print('availaible'),
                                              /*ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: textWithBoldStyle(
                                                    //
                                                    value.message,
                                                    //
                                                    Colors.white,
                                                    14.0,
                                                  ),
                                                ),
                                              ),*/
                                              setState(() {
                                                strUsernameVerified = '2';
                                              }),
                                            }
                                        });
                              },
                              child: (strUsernameVerified == '2')
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      width: 54.0,
                                      height: 54.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          27.0,
                                        ),
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 4,
                                        ),
                                      ),
                                      child: (strUsernameVerified == '1')
                                          ? const CircularProgressIndicator()
                                          : const Icon(
                                              Icons.check,
                                            ),
                                    )
                                  : Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      width: 54.0,
                                      height: 54.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          27.0,
                                        ),
                                        border: Border.all(
                                          color: navigationColor,
                                          width: 4,
                                        ),
                                      ),
                                      child: (strUsernameVerified == '1')
                                          ? const CircularProgressIndicator()
                                          : const Icon(
                                              Icons.check,
                                            ),
                                    ),
                            ),
                          ],
                        ),
                        //
                        /*(strUsernameVerified == '0')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // a
                                children: [
                                  Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    child: NeoPopButton(
                                      color: Colors.white,
                                      onTapUp: () {
                                        //
                                        // s

                                        //
                                        QuickAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          type: QuickAlertType.loading,
                                          title: 'Please wait...',
                                          text: 'verifying...',
                                          onConfirmBtnTap: () {
                                            if (kDebugMode) {
                                              print('some click');
                                            }
                                          },
                                        );
                                        //

                                        verifyApiCall
                                            .verifyWB(
                                              contUserName.text,
                                            )
                                            .then((value) => {
                                                  // print('object'),
                                                  // print(value.successStatus),
                                                  if (value.successStatus ==
                                                      'success') ...[
                                                    //
                                                    setState(() {
                                                      Navigator.pop(context);
                                                      strUsernameVerified = '1';
                                                    }),
                                                  ] else ...[
                                                    //
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            navigationColor,
                                                        content:
                                                            textWithBoldStyle(
                                                          //
                                                          value.message,
                                                          //
                                                          Colors.white,
                                                          14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Navigator.pop(context),
                                                    //
                                                  ]
                                                });
                                        //
                                      },
                                      onTapDown: () => HapticFeedback.vibrate(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          textWithBoldStyle(
                                            'Verify',
                                            Colors.green,
                                            16.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    right: 20,
                                    bottom: 0,
                                  ),
                                  child: textWithBoldStyle(
                                    'availaible',
                                    Colors.green,
                                    12.0,
                                  ),
                                ),
                              ),*/
                        //
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10.0,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            controller: contName,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 24.0,
                              ),
                              border: InputBorder.none,
                              hintText: 'Full Name',
                              contentPadding:
                                  EdgeInsets.only(top: 14, left: 20.0),
                            ),
                            onTap: () {
                              // category_list_POPUP('str_message');
                            },
                            // validation
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                        ),
                        //
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            controller: contEmail,
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
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            readOnly: false,
                            controller: contPhone,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.phone_iphone_rounded,
                                size: 24.0,
                              ),
                              border: InputBorder.none,
                              hintText: 'Phone number',
                              contentPadding:
                                  EdgeInsets.only(top: 14, left: 20.0),
                            ),
                            onTap: () {
                              // category_list_POPUP('str_message');
                            },
                            // validation
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone';
                              }
                              return null;
                            },
                          ),
                        ),
                        //
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
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            controller: contPassword,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.lock_outlined,
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
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            right: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            controller: contConfirmPassword,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.lock_outlined,
                                size: 24.0,
                              ),
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              contentPadding:
                                  EdgeInsets.only(top: 14, left: 20.0),
                            ),
                            onTap: () {
                              // category_list_POPUP('str_message');
                            },
                            // validation
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter confirm';
                              }
                              return null;
                            },
                          ),
                        ),
                        //
                        (strUsernameVerified == '2')
                            ? InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    //
                                    QuickAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      type: QuickAlertType.loading,
                                      title: 'Please wait...',
                                      text: 'processing',
                                      onConfirmBtnTap: () {
                                        if (kDebugMode) {
                                          print('some click');
                                        }
                                      },
                                    );
                                    //
                                    // sign up via firebase
                                    funcSignInDummyAccount();
                                    //
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
                                      'Sign Up',
                                      Colors.white,
                                      18.0,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: Center(
                                  child: textWithBoldStyle(
                                    'Sign Up',
                                    Colors.white,
                                    18.0,
                                  ),
                                ),
                              ),
                        //
                        /*Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                // color: Colors.pink,
                                width: MediaQuery.of(context).size.width,
                                height: 54,
                                decoration: BoxDecoration(
                                  // image: const DecorationImage(
                                  //   image: AssetImage(
                                  //     'assets/images/logo.png',
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  color: const Color.fromRGBO(
                                    75,
                                    136,
                                    237,
                                    1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //
                                    Image.asset(
                                      'assets/images/facebook.png',
                                    ),

                                    //
                                    Center(
                                      child: textWithBoldStyle(
                                        'Facebook',
                                        Colors.white,
                                        14.0,
                                      ),
                                    ),
                                    //
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
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
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/google.png',
                                      ),
                                    ),
                                    //
                                    Center(
                                      child: textWithBoldStyle(
                                        'Google',
                                        Colors.black,
                                        14.0,
                                      ),
                                    ),
                                    //
                                    const SizedBox(
                                      width: 10,
                                    )
                                    //
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),*/
                        //
                        textWithBoldStyle(
                          'Forgot password ?',
                          const Color.fromRGBO(
                            230,
                            223,
                            74,
                            1,
                          ),
                          16.0,
                        ),
                        //
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' - Sign In',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  //
  funcSignInDummyAccount() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: contEmail.text,
            // email: 'test03@gmail.com',
            password: '12345678@',
          )
          .then((value) => {
                (strImage == '1')
                    ? signUpWithimageWB(
                        value.user!.uid.toString(),
                      )
                    : signApiCall
                        .signUpWB(
                            contUserName.text.toString(),
                            contName.text.toString(),
                            contEmail.text.toString(),
                            contPhone.text.toString(),
                            contPassword.text.toString(),
                            value.user!.uid.toString())
                        .then((value) {
                        if (kDebugMode) {
                          print(value);
                          print('successfully registered');
                          //
                        }
                        // success
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Successfully Registered',
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                        //
                      }),

                //
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        //
        Navigator.pop(context);
        //
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: navigationColor,
            content: textWithBoldStyle(
              //
              'The account already exists for that email.',
              //
              Colors.white,
              14.0,
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        // print(e);
      }
    }
  }

  //
  //
  void openCameraAndGalleryPopUP(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  imageFile = File(pickedFile.path);
                });
              }
            },
            child: textWithRegularStyle(
              'Open Camera',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('object');
                  }
                  // when user select photo from gallery
                  setState(() {
                    strImage = '1';
                    imageFile = File(pickedFile.path);
                  });
                });
              }
            },
            child: textWithRegularStyle(
              'Open Gallery',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.black,
              14.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  // UPLOAD DATA WITH IMAGE
  signUpWithimageWB(
    String firebaseId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState(() {
    // strPostType = 'loader';
    // });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    request.fields['action'] = 'registration';

    request.fields['fullName'] = contName.text.toString();
    request.fields['email'] = contEmail.text.toString();
    request.fields['contactNumber'] = contPhone.text.toString();
    request.fields['password'] = contPassword.text.toString();
    request.fields['username'] = contUserName.text.toString();
    request.fields['role'] = 'Member';
    request.fields['firebaseId'] = firebaseId.toString();
    request.fields['deviceToken'] = prefs.getString('deviceToken').toString();

    if (kDebugMode) {
      print('check');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile!.path,
      ),
    );

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    if (kDebugMode) {
      print(responsedData);
    }

    if (responsedData['status'].toString().toLowerCase() == 'success') {
      imageFile = null;

      if (kDebugMode) {
        print('success');
      }

//
      // success
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Successfully Registered',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      //
      //
    } else {
      // setState(() {
      // strPostType = '1';
      // });
    }

    //
  }
  //
}
