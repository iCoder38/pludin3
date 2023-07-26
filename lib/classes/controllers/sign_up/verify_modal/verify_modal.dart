import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class VerifyResponse {
  final String successStatus;
  final String message;
  // final String ;

  const VerifyResponse({required this.successStatus, required this.message});

  factory VerifyResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResponse(
      successStatus: json['status'],
      message: json['msg'],
    );
  }
}

class VerifyModal {
  verifyWB(
    String username,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'checkusername',
          'username': username,
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('=========> 201');
        print(response.body);
      }

      return VerifyResponse.fromJson(jsonDecode(response.body));
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

        return VerifyResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return VerifyResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return VerifyResponse(
        successStatus: 'Server Issue',
        message: 'Server Issue'.toString(),
      );
    }
  }
}
