// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/forgot_password/reset_password/reset_password.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../header/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //
  TextEditingController contEmailAddress = TextEditingController();
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
              'RESET PASSWORD',
              Colors.black,
              26.0,
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
            //
            textWithBoldStyle(
              'Email address',
              Colors.black,
              18.0,
            ),
            //
            const SizedBox(
              height: 10,
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                left: 40,
                right: 40.0,
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
                  controller: contEmailAddress,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Email address",
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            //
            const SizedBox(
              height: 20,
            ),
            //
            InkWell(
              onTap: () {
                //
                QuickAlert.show(
                  context: context,
                  barrierDismissible: false,
                  type: QuickAlertType.loading,
                  title: 'Please wait...',
                  text: 'checking your account...',
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
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 40.0,
                  right: 40.0,
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
                    'Send Instructions',
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
          'action': 'forgotpassword',
          'email': contEmailAddress.text.toString(),
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
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  strGetEmail: contEmailAddress.text.toString(),
                ),
              ),
            );
            //
          },
        );
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
