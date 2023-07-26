import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class EditProfileResponse {
  final String successStatus;
  final String message;
  // final String ;

  const EditProfileResponse(
      {required this.successStatus, required this.message});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      successStatus: json['status'],
      message: json['msg'],
    );
  }
}

class EditProfileModal {
  editProfileWB(
    String username,
    String userId,
    String fullName,
    String email,
    String contactNumber,
    String address,
    // String firebaseId,
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
          'action': 'editprofile',
          'userId': userId.toString(),
          'fullName': fullName,
          'email': email,
          'contactNumber': contactNumber,
          'address': address,
          // 'username': username,
          // 'role': 'Member',
          // 'firebaseId': firebaseId.toString()
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('=========> 201');
        print(response.body);
      }

      return EditProfileResponse.fromJson(jsonDecode(response.body));
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
          print('=========> EDIT SUCCESS <===========');
        }

        return successStatus;
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return EditProfileResponse(
          successStatus: successText,
          message: successStatus['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return EditProfileResponse(
        successStatus: 'Server Issue',
        message: 'Server Issue'.toString(),
      );
    }
  }
}
