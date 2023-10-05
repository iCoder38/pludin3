// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;

class FriendResponse {
  final allData;
  // final String ;

  const FriendResponse({this.allData});

  factory FriendResponse.fromJson(Map<String, dynamic> json) {
    return FriendResponse(
      allData: json,
    );
  }
}

class MyFriendsList {
  funcMyFriendsListOrRequestWB(
    String user_id,
    String status,
    String type,
  ) async {
    //
    var response;
    //
    if (type == '0') {
      response = await http.post(
        Uri.parse(
          applicationBaseURL,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'action': 'friendlist',
            'userId': user_id,
            'status': status.toString()
          },
        ),
      );
    } else if (type == '1') {
      response = await http.post(
        Uri.parse(
          applicationBaseURL,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'action': 'friendlist',
            'userId': user_id,
            'status': status.toString(),
            'friendType': type.toString(),
          },
        ),
      );
    } else if (type == '2') {
      response = await http.post(
        Uri.parse(
          applicationBaseURL,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'action': 'friendlist',
            'userId': user_id,
            'status': status.toString(),
            'friendType': type.toString(),
          },
        ),
      );
    }

    //
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('==========> 200');
      }

      var getData = jsonDecode(response.body);
      if (kDebugMode) {
        print(getData);
        print(getData.runtimeType);
        print('=========> ok ok  <===========');
      }

      Map<String, dynamic> successStatus = jsonDecode(response.body);
      if (kDebugMode) {
        print(successStatus);
      }

      var getData2 = jsonDecode(response.body);
      if (kDebugMode) {
        print(getData2);
        // print(getData2.runtimeType);
        // print('=========> ok2 ok2  <===========');
      }

      // print('rajput ==========> 200');

      var successText = successStatus['status'].toString().toLowerCase();

      // after SUCCESS
      if (successText == "success") {
        if (kDebugMode) {
          print('=========> HOME SUCCESS <===========');
        }

        var getData = jsonDecode(response.body);
        if (kDebugMode) {
          print(getData);
          print(getData.runtimeType);
        }
        var arr = [];
        for (Map i in getData['data']) {
          arr.add(i);
        }
        return arr;
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return FriendResponse(
          allData: successStatus,
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return FriendResponse(
        // successStatus: 'Server Issue',
        // message: 'Server Issue'.toString(),
        allData: 'Server Issue'.toString(),
      );
    }
  }
}
