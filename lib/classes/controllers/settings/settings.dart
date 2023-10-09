import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/custom_app_bar/custom_app_bar.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/login/login.dart';
import 'package:pludin/classes/controllers/settings/email_Settings/email_settings.dart';
import 'package:pludin/classes/controllers/settings/general_settings/general_settings.dart';
import 'package:pludin/classes/controllers/settings/notification_settings/notification_settings.dart';
import 'package:pludin/classes/controllers/settings/privacy_setttings/privacy_settings.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../database/database_helper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //var
  // ignore: prefer_typing_uninitialized_variables
  var getData;
  var strSettingsPrivacyLoader = '0';
  var strSettingsNotificationLoader = '0';
  var strSettingsEmailLoader = '0';
  var strSettingsDeleteAccountLoader = '0';

  late DataBase handler;
  //
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //
  var strGetUserId = '';
  var strImage = '';
  var strName = '';
  var strUsername = '';
  var strEmail = '';
  //
  @override
  void initState() {
    //
    handler = DataBase();
    //
    funcGetLocalDBdata();
    //
    super.initState();
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
                    //
                    strGetUserId = value[i].userId.toString(),
                    strName = value[i].fullName.toString(),
                    strUsername = value[i].username.toString(),
                    strEmail = value[i].email.toString(),
                    strImage = value[i].image.toString(),
                    //
                    setState(() {
                      if (kDebugMode) {
                        print('==========================================');
                        print('=====> LOGIN USER DATA IN SETTINGS <=====');
                        print('==========================================');
                        print('Login user id ====> $strGetUserId');
                        print('Login name =======> $strName');
                        print('Login username ===> $strUsername');
                        print('Login email ======> $strEmail');
                        print('Login image ======> $strImage');
                        print('==========================================');
                        print('==========================================');
                      }
                      //
                      //
                      funcFetchAllSettings();
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
      key: scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomAppBarScreen(
              strForMenu: '1',
              getScaffold: scaffoldKey,
              strTextOrImage: 'Settings',
            ),
            //
            Stack(
              children: [
                (strImage == '')
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(
                            16,
                            16,
                            16,
                            1,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.4,
                          ),
                        ),
                        // child: widget
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(
                            16,
                            16,
                            16,
                            1,
                          ),
                          // image: DecorationImage(
                          //   image: AssetImage(
                          //     //
                          //     strImage,
                          //     //
                          //   ),
                          //   fit: BoxFit.cover,
                          //   opacity: 0.4,
                          // ),
                        ),
                        child: Opacity(
                          opacity: .4,
                          child: Image.network(
                            //
                            strImage.toString(),
                            //
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                //
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: textWithBoldStyle(
                      //
                      strName.toString(),
                      //
                      Colors.white,
                      22.0,
                    ),
                  ),
                ),
                //
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 80.0,
                    ),
                    child: textWithBoldStyle(
                      //
                      '@$strUsername',
                      //
                      const Color.fromARGB(255, 10, 211, 234),
                      18.0,
                    ),
                  ),
                ),
                //
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 120.0,
                    ),
                    child: textWithBoldStyle(
                      //
                      strEmail.toString(),
                      //
                      const Color.fromRGBO(
                        212,
                        202,
                        67,
                        1,
                      ),
                      18.0,
                    ),
                  ),
                ),
                //
                Center(
                  child: (strImage == '')
                      ? Container(
                          margin: const EdgeInsets.only(
                            top: 160.0,
                          ),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              75.0,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 8.0,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/icons/avatar.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                            top: 160.0,
                          ),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              75.0,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 8.0,
                            ),
                          ),
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
                //
              ],
            ),
            //
            const SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  pushToEdit(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWithRegularStyle(
                        'General Settings',
                        Colors.black,
                        18.0,
                      ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: 1,
              // child: widget
            ),

            ///
            ///
            //
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  //
                  pushToPrivacy(context);
                  //
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (strSettingsPrivacyLoader == '0')
                          ? CircularProgressIndicator(
                              color: navigationColor,
                            )
                          : textWithRegularStyle(
                              'Privacy Settings',
                              Colors.black,
                              18.0,
                            ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: 1,
              // child: widget
            ),

            ///
            ///
            //
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  //
                  pushToNotification(context);
                  //
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (strSettingsNotificationLoader == '0')
                          ? const CircularProgressIndicator(
                              color: Colors.pink,
                            )
                          : textWithRegularStyle(
                              'Notificaion Settings',
                              Colors.black,
                              18.0,
                            ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: 1,
              // child: widget
            ),

            ///
            ///
            //
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  //
                  pushToEmail(context);
                  //
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (strSettingsEmailLoader == '0')
                          ? const CircularProgressIndicator(
                              color: Colors.purple,
                            )
                          : textWithRegularStyle(
                              'Email Settings',
                              Colors.black,
                              18.0,
                            ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: 1,
              // child: widget
            ),

            ///
            ///
            //
            const SizedBox(
              height: 20,
            ),
            (strSettingsDeleteAccountLoader == '1')
                ? const CircularProgressIndicator()
                : Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('delete account');
                        }
                        //
                        QuickAlert.show(
                          context: context,
                          barrierColor: Colors.blueGrey,
                          type: QuickAlertType.confirm,
                          text:
                              'Do you want to Delete your account ? Your all data will be deleted .',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () {
                            if (kDebugMode) {
                              print('some click');
                            }
                            Navigator.pop(context);

//
                            funDeleteAccountPermanantly();
//

                            //

                            //
                          },
                        );
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWithBoldStyle(
                              'Delete Account',
                              Colors.red,
                              18.0,
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            //
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
              ),
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              height: 1,
              // child: widget
            ),
            //
          ],
        ),
      ),
    );
  }

  //
  Future<void> pushToEdit(BuildContext context) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GeneralSettingsScreen(),
      ),
    );

    // ignore: prefer_interpolation_to_compose_strings
    // print('result =====> ' + result);

// get_back_from_add_notes

    if (!mounted) return;

    //
    if (result == 'from_general_setting') {
      funcGetLocalDBdata();
    }

    //
  }

  Future<void> pushToPrivacy(BuildContext context) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacySettingsScreen(
          getPrivacyData: getData['data'],
          strLoginUserId: strGetUserId.toString(),
        ),
      ),
    );

    // ignore: prefer_interpolation_to_compose_strings
    // print('result =====> ' + result);

// get_back_from_add_notes

    if (!mounted) return;

    //
    if (result == 'from_privacy_setting') {
      funcGetLocalDBdata();
    }

    //
  }

  Future<void> pushToNotification(BuildContext context) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationSettingsScreen(
          getPNotificationData: getData['data'],
          strLoginUserId: strGetUserId.toString(),
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'from_notification_setting') {
      setState(() {
        // strSettingsPrivacyLoader = '1';
        strSettingsNotificationLoader = '0';
      });
      funcGetLocalDBdata();
    }
  }

  Future<void> pushToEmail(BuildContext context) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailSettingsScreen(
          getEmailData: getData['data'],
          strLoginUserId: strGetUserId.toString(),
        ),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'from_email_setting') {
      setState(() {
        // strSettingsPrivacyLoader = '1';
        strSettingsEmailLoader = '0';
      });
      funcGetLocalDBdata();
    }
  }

  //
  // upload feeds data to time line
  funcFetchAllSettings() async {
    //
    setState(() {
      strSettingsPrivacyLoader = '0';
    });
    //
    if (kDebugMode) {
      print('=====> POST : UPLOAD ONLY TEXT ');
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'getsetting',
          'userId': strGetUserId.toString(),
        },
      ),
    );

    // convert data to dict
    getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        setState(() {
          // storeSettingsData = getData['data'];
          strSettingsPrivacyLoader = '1';
          strSettingsNotificationLoader = '1';
          strSettingsEmailLoader = '1';
        });
        if (kDebugMode) {
          // print('asadqfsgfd' + storeSettingsData);
        }
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
  funDeleteAccountPermanantly() async {
    //
    setState(() {
      strSettingsDeleteAccountLoader = '1';
    });
    //
    if (kDebugMode) {
      print('=====> POST : DELETE PERMANENTLY');
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'userdelete',
          'userId': strGetUserId.toString(),
          'OTP': ''
        },
      ),
    );

    // convert data to dict
    getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
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
        // });
        if (kDebugMode) {
          // print('asadqfsgfd' + storeSettingsData);
        }
        //
        setState(() {
          strSettingsDeleteAccountLoader = '0';
        });
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
}
