// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pludin/classes/change_password/change_password.dart';
import 'package:pludin/classes/controllers/UI/designs/ui_BG.dart/ui_background.dart';
import 'package:pludin/classes/controllers/settings/edit_profile_modal/edit_profile_modal.dart';
import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../database/database_helper.dart';
import '../../database/database_modal.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  //
  late DataBase handler;
  //
  final editProfileApiCall = EditProfileModal();
  //
  late final TextEditingController contName;
  late final TextEditingController contEmail;
  late final TextEditingController contPhone;
  late final TextEditingController contAddress;
  late final TextEditingController contUsername;
  //
  final formKey = GlobalKey<FormState>();
  //
  var strLoginUserId = '';
  var strName = '';
  var strUsername = '';
  var strEmail = '';
  var strAddress = '';
  var strPhone = '';
  var strImage = '';
  //
  var strImageStatus = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  @override
  void initState() {
    //
    handler = DataBase();
    //
    funcGetLocalDBdata();
    //
    contName = TextEditingController();
    contEmail = TextEditingController();
    contPhone = TextEditingController();
    contAddress = TextEditingController();
    contUsername = TextEditingController();
    //
    super.initState();
  }

  @override
  void dispose() {
    contName.dispose();
    contEmail.dispose();
    contPhone.dispose();
    contAddress.dispose();
    contUsername.dispose();

    super.dispose();
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
            print('NO, LOCAL DB DOES NOT HAVE ANY DATA in general setting');
          }
          // call firebase server
        } else {
          if (kDebugMode) {
            print('YES, LOCAL DB HAVE SOME DATA in general setting');
          }
          //
          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    strName = value[i].fullName.toString(),
                    strUsername = value[i].username.toString(),
                    strEmail = value[i].email.toString(),
                    strAddress = value[i].address.toString(),
                    strPhone = value[i].contactNumber.toString(),
                    strImage = value[i].image.toString(),

                    if (strImage == '')
                      {strImageStatus = '0'}
                    else
                      {strImageStatus = '1'},
                    //
                    setState(() {
                      if (kDebugMode) {
                        print('=====> LOGIN USERDATA IN SETTINGS <=====');
                        print(strName);
                        print(strUsername);
                        print(strEmail);
                        print(strImage);
                      }
                      //
                      contName.text = strName;
                      contEmail.text = strEmail;
                      contPhone.text = strPhone;
                      contAddress.text = strAddress;
                      contUsername.text = strUsername;
                      //
                    }),
                  }
                //
              });
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'General Settings',
          Colors.white,
          20.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'from_general_setting');
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
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
              child: (strImageStatus == '0')
                  ? Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        // color: Color.fromRGBO(
                        //   57,
                        //   49,
                        //   157,
                        //   1,
                        // ),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/sign_up_image_border.png',
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      // child: widget
                    )
                  : Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(),
                      child: Opacity(
                        opacity: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.network(
                            // width: 80,
                            // height: 80,

                            //
                            strImage.toString(),
                            //
                            fit: BoxFit.cover,
                          ),
                        ),
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
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
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
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              controller: contEmail,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.mail_outline_outlined,
                                  size: 24.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Email Address',
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
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextFormField(
                              readOnly: false,
                              controller: contPhone,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 24.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Phone number',
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
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              readOnly: false,
                              controller: contAddress,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.pin_drop,
                                  size: 24.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Address',
                              ),
                              onTap: () {
                                // category_list_POPUP('str_message');
                              },
                              // validation
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        //
                        InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              if (kDebugMode) {
                                print('object');
                              }
                              //

                              funcUpdateGeneralSetting();

                              //
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
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
                                'Update Details',
                                Colors.white,
                                18.0,
                              ),
                            ),
                          ),
                        ),

                        //

                        InkWell(
                          onTap: () {
                            //
                            Navigator.pushNamed(
                              context,
                              'push_to_unblock_friends_setting_screen',
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(
                                112,
                                207,
                                214,
                                1,
                              ),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                'Unblock Friends',
                                Colors.white,
                                18.0,
                              ),
                            ),
                          ),
                        ),
                        //
                        InkWell(
                          onTap: () {
                            //
                            if (kDebugMode) {
                              print('change password click');
                            }
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                            //
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 54,
                            decoration: BoxDecoration(
                              color: appBlueColor,
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                'Change Password',
                                Colors.white,
                                18.0,
                              ),
                            ),
                          ),
                        ),
                        //

                        //
                        const SizedBox(
                          height: 10,
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
  funcUpdateGeneralSetting() {
    //
    // keyboard dismiss when click outside
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'updating...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    editProfileApiCall
        .editProfileWB(
          contUsername.text,
          strLoginUserId,
          contName.text,
          contEmail.text,
          contPhone.text,
          contAddress.text,
        )
        .then((value) => {
              // print(value),
              funcRenewDB(value),
            });
    //
  }

  // remove DB and insert new details inDB
  funcRenewDB(data) {
    if (kDebugMode) {
      print('Delete old DB and renew DB with new data');
      print(data['data']);
    }

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
      print('EDITED NEW DATA ADDED IN LOCAL DB');
    }
    handler.insertPlanets(loginUserDataForLocalDB);
    //
    Navigator.pop(context);
  }

  //
  // UPLOAD DATA WITH IMAGE
  signUpWithimageWB() async {
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'updating...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    request.fields['action'] = 'editprofile';

    request.fields['userId'] = strLoginUserId.toString();

    /*request.fields['fullName'] = contName.text.toString();
    request.fields['contactNumber'] = contPhone.text.toString();
    request.fields['address'] = contAddress.text.toString();*/

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
      print('object 3.3.3.3.3');
      print(responsedData['data']);
    }

    if (responsedData['status'].toString().toLowerCase() == 'success') {
      imageFile = null;

      if (kDebugMode) {
        print('success');
      }
      //
      // success
      // Navigator.pop(context);

      //
      handler.deletePlanet(1);
      //
      List<Planets> loginUserDataForLocalDB = [];
      for (int i = 0; i < 1; i++) {
        Planets one = Planets(
          id: 1,
          userId: responsedData['data']['userId'].toString(),
          fullName: responsedData['data']['fullName'].toString(),
          lastName: responsedData['data']['lastName'].toString(),
          middleName: responsedData['data']['middleName'].toString(),
          email: responsedData['data']['email'].toString(),
          gender: responsedData['data']['gender'].toString(),
          contactNumber: responsedData['data']['contactNumber'].toString(),
          role: responsedData['data']['role'].toString(),
          dob: responsedData['data']['dob'].toString(),
          address: responsedData['data']['address'].toString(),
          zipCode: responsedData['data']['zipCode'].toString(),
          city: responsedData['data']['city'].toString(),
          state: responsedData['data']['state'].toString(),
          status: responsedData['data']['status'].toString(),
          image: responsedData['data']['image'].toString(),
          device: responsedData['data']['device'].toString(),
          deviceToken: responsedData['data']['deviceToken'].toString(),
          socialId: responsedData['data']['socialId'].toString(),
          socialType: responsedData['data']['socialType'].toString(),
          latitude: responsedData['data']['latitude'].toString(),
          longitude: responsedData['data']['longitude'].toString(),
          firebaseId: responsedData['data']['firebaseId'].toString(),
          username: responsedData['data']['username'].toString(),
        );

        loginUserDataForLocalDB.add(one);
      }
      //
      // print('object 3333');
      if (kDebugMode) {
        print(loginUserDataForLocalDB);
        print('EDITED NEW DATA ADDED IN LOCAL DB for IMAGE');
      }
      handler.insertPlanets(loginUserDataForLocalDB);
      //
      Navigator.pop(context);
      //
      funcGetLocalDBdata();
      //
    } else {
      // setState(() {
      // strPostType = '1';
      // });
    }

    //
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
                    strImageStatus = '1';
                    imageFile = File(pickedFile.path);
                  });
                  signUpWithimageWB();
                  //
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
}
