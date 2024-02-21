// ignore_for_file: non_constant_identifier_names

// import 'package:cameroon_2/classes/change_password/change_password_modal.dart';
// import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
// import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pludin/classes/header/utils.dart';

import '../controllers/database/database_helper.dart';
import '../controllers/drawer/drawer.dart';
import 'change_password_modal.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/classes/change_password/change_password_modal.dart';
// import 'package:triple_r_custom/custom_files/app_bar/appbar.dart';
// import 'package:triple_r_custom/custom_files/drawer/drawer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //
  var loader_indicator = '0';
  // name
  TextEditingController cont_txt_old_password = TextEditingController();
  // email
  TextEditingController cont_txt_new_password = TextEditingController();
  // password
  TextEditingController cont_txt_confirm_password = TextEditingController();
  //
  final change_password_service = ChangePasswordModal();
  //
  var strGetUserId = '';
  late DataBase handler;
  //
  @override
  void initState() {
    super.initState();

    //
    handler = DataBase();
    //
    funcGetLocalDBdata();
  }

  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
        // if (kDebugMode) {
        //   print(value);
        //   print(value.length);
        // }
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
                    strGetUserId = value[i].userId.toString(),
                  },
                //

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
        // automaticallyImplyLeading: false,
        title: textWithRegularStyle(
          'Change Password',
          Colors.white,
          14.0,
        ),
        backgroundColor: navigationColor,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(
                    // image name
                    'assets/images/changePassword.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(
                    // image name
                    'assets/icons/lock.png',
                  ),
                  // fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 360.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 400 - 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    24,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: textWithBoldStyle(
                        'Change Password',
                        Colors.black,
                        16.0,
                      ),
                    ),
                  ),
                  // Container(
                  //   color: Colors.transparent,
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 30,
                  //   child: const Center(
                  //     child: Text(
                  //       'Sign in to your account',
                  //       style: TextStyle(
                  //         fontFamily: 'Avenir Next',
                  //         fontSize: 16.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      obscureText: true,
                      controller: cont_txt_old_password,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: 'old password',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      controller: cont_txt_new_password,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: 'new password',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      controller: cont_txt_confirm_password,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: 'confirm passwrod',
                        prefixStyle: const TextStyle(
                          fontFamily: 'Avenir Next',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (cont_txt_old_password.text == '') {
                        _showMyDialog('Old password should not be empty.');
                      } else if (cont_txt_new_password.text == '') {
                        _showMyDialog('New passwords should not be empty.');
                      } else if (cont_txt_confirm_password.text == '') {
                        _showMyDialog('Confirm passwords should not be empty.');
                      } else if (cont_txt_new_password.text !=
                          cont_txt_confirm_password.text) {
                        _showMyDialog('Passwords not match.');
                      } else {
                        //
                        setState(() {
                          loader_indicator = '1';
                        });
                        funcChangePasswordWB();
                        //
                      }
                    },
                    child: (loader_indicator == '1')
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            height: 54,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: navigationColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                'Submit',
                                Colors.white,
                                16.0,
                              ),
                            ),
                          ),
                    /**/
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 750.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 50,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  funcChangePasswordWB() {
    change_password_service
        .update_password_WB(
      strGetUserId.toString(),
      cont_txt_old_password.text,
      cont_txt_new_password.text,
    )
        .then(
      (value) {
        // print('object');
        if (kDebugMode) {
          print(value.success_status);
        }
        if (value.success_status == 'Fails'.toLowerCase()) {
          setState(() {
            loader_indicator = '0';
          });
          _showMyDialog(
            value.message.toString(),
          );
        } else {
          setState(() {
            loader_indicator = '0';
          });
          const snackBar = SnackBar(
            backgroundColor: Colors.green,
            content: Text('Successfully updated.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // Navigator.pop(context);
          cont_txt_old_password.text = '';
          cont_txt_new_password.text = '';
          cont_txt_confirm_password.text = '';
        }
      },
    );
  }

  //
  Future<void> _showMyDialog(
    String str_message,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            //
            'Alert',
            //
            style: TextStyle(
              // fontFamily: font_family_name,
              fontSize: 16.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWithRegularStyle(
                  str_message,
                  Colors.black,
                  14.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Dismiss',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
