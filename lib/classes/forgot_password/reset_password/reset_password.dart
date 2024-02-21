// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

import '../../header/utils.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.strGetEmail});

  final String strGetEmail;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  //
  TextEditingController contOTP = TextEditingController();
  TextEditingController contNewPassword = TextEditingController();
  TextEditingController contConfirmPassword = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Reset Password',
          Colors.white,
          16.0,
        ),
        backgroundColor: navigationColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //
            const SizedBox(
              height: 20,
            ),
            //
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Image.asset(
                'assets/icons/forgot_password.png',
              ),
            ),
            //
            const SizedBox(
              height: 10,
            ),
            //
            textWithBoldStyle(
              'Create New Password',
              Colors.black,
              22.0,
            ),
            //
            const SizedBox(
              height: 10,
            ),
            //
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Center(
                child: textWithRegularStyle(
                  'Enter your email address and you will',
                  Colors.grey,
                  14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Center(
                child: textWithRegularStyle(
                  'receive an OTP on your registered  ',
                  Colors.grey,
                  14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Center(
                child: textWithRegularStyle(
                  'email ID to reset new password.',
                  Colors.grey,
                  14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),

            const SizedBox(
              height: 10,
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20.0,
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Align(
                child: TextField(
                  controller: contOTP,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Enter OTP",
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            //
            const SizedBox(
              height: 10,
            ),

            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20.0,
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Align(
                child: TextField(
                  controller: contNewPassword,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Enter New Password",
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            //
            const SizedBox(
              height: 10,
            ),

            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20.0,
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Align(
                child: TextField(
                  controller: contConfirmPassword,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Enter Confirm Password",
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            //
            const SizedBox(
              height: 10,
            ),
            //
            InkWell(
              onTap: () {
                //
                if (contNewPassword.text == contConfirmPassword.text) {
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
                  funcUploadDataWithOnlyText();
                  //
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'Passwords not match.',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: navigationColor,
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
                child: Center(
                  child: textWithBoldStyle(
                    'Update',
                    Colors.white,
                    16.0,
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              height: 20,
            ),
            //
          ],
        ),
      ),
    );
  }

  //
  // upload feeds data to time line
  funcUploadDataWithOnlyText() async {
    //

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
          'action': 'resetpassword',
          'OTP': contOTP.text.toString(),
          'password': contNewPassword.text.toString(),
          'email': widget.strGetEmail.toString(),
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: getData['msg'],
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            //

            //
          },
        );
        //
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: getData['msg'],
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );

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
}
