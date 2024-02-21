// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SignInResponse {
  final String successStatus;
  final String message;
  final allData;
  // final String ;

  const SignInResponse(
      {required this.successStatus, required this.message, this.allData});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      successStatus: json['status'],
      message: json['msg'],
      allData: json,
    );
  }
}

class SignInModal {
  signInWB(
    String email,
    String password,
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
          'action': 'login',
          'email': email,
          'password': password,
          'device': 'iOS'
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('=========> 201');
        print(response.body);
      }

      return SignInResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      if (kDebugMode) {
        print('==========> 200');
        print(response.body);
      }

      Map<String, dynamic> successStatus = jsonDecode(response.body);
      if (kDebugMode) {
        print(successStatus);
      }

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('key_login_user_data', json.encode(successStatus));

      // SharedPreferences prefs = await SharedPreferences.getInstance();

      //
      // await prefs.setInt('userId', successStatus['data']['userId']);
      // await prefs.setString('fullName', successStatus['data']['fullName']);
      //

      var successText = successStatus['status'].toString().toLowerCase();

      // after SUCCESS
      if (successText == "success") {
        if (kDebugMode) {
          print('=========> LOGIN SUCCESS <===========');
        }

        //
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.clear();
        //
        // save login data locally
        // Map<String, dynamic> get_data = jsonDecode(response.body);
        // Map<String, dynamic> user = get_data['data'];
        // await preferences.setInt('userId', user['userId']);
        //

        return SignInResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
          allData: successStatus,
        );
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return SignInResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return SignInResponse(
        successStatus: 'Server Issue',
        message: 'Server Issue'.toString(),
      );
    }
  }
}

/*funcSaveloginUserLocally() {
  //
  DataBase handler;
  //
  handler.retrievePlanets().then(
    (value) {
      if (kDebugMode) {
        print(value.length);
      }
      if (value.isEmpty) {
        if (kDebugMode) {
          print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
        }
        // call firebase server
        setState(() {
          strCategoryLoader = '1';
        });
      } else {
        if (kDebugMode) {
          print('YES, LOCAL DB HAVE SOME DATA');
        }
        //
        setState(() {
          strCategoryLoader = '2';
        });
      }
    },
  );
}*/
