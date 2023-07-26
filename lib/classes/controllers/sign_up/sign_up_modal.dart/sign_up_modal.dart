import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SignUpResponse {
  final String successStatus;
  final String message;
  // final String ;

  const SignUpResponse({required this.successStatus, required this.message});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      successStatus: json['status'],
      message: json['msg'],
    );
  }
}

class SignUpModal {
  signUpWB(
    String username,
    String fullName,
    String email,
    String contactNumber,
    String password,
    String firebaseId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      /*
      action:registration
fullName:
email:
contactNumber:
password:
role:Member
*/
      body: jsonEncode(
        <String, String>{
          'action': 'registration',
          'fullName': fullName,
          'email': email,
          'contactNumber': contactNumber,
          'password': password,
          'username': username,
          'role': 'Member',
          'firebaseId': firebaseId.toString(),
          'deviceToken': prefs.getString('deviceToken').toString(),
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('=========> 201');
        print(response.body);
      }

      return SignUpResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      if (kDebugMode) {
        print('==========> 200');
        print(response.body);
      }

      Map<String, dynamic> successStatus = jsonDecode(response.body);
      var successText = successStatus['status'].toString().toLowerCase();

      // after SUCCESS
      if (successText == "success") {
        if (kDebugMode) {
          print('=========> SIGNUP SUCCESS <===========');
        }

        return SignUpResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return SignUpResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return SignUpResponse(
        successStatus: 'Server Issue',
        message: 'Server Issue'.toString(),
      );
    }
  }
}
