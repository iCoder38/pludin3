// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;

class SearchFriendResponse {
  final allData;
  // final String ;

  const SearchFriendResponse({this.allData});

  factory SearchFriendResponse.fromJson(Map<String, dynamic> json) {
    return SearchFriendResponse(
      allData: json,
    );
  }
}

// action:userlist

class SearchFriendModal {
  searchFriendsWB(
    String userId,
    String strKeyword,
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
          'action': 'userlist',
          'userId': userId,
          'keyword': strKeyword.toString(),
        },
      ),
    );
    // print();

    // if (response.statusCode == 201) {
    //   if (kDebugMode) {
    //     print('=========> 201');
    //     print(response.body);
    //   }

    //   return HomeResponse.fromJson(jsonDecode(response.body));
    // } else
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('==========> 200');
        // print(response.body);
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
        print(getData2.runtimeType);
        print('=========> ok2 ok2  <===========');
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
        // print('check =======> $arr');
        // print('check count =======> ${arr.length}');
        // return HomeResponse(allData: arr.toString());
        return arr;
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return SearchFriendResponse(
          // successStatus: successText,
          // message: successStatus['msg'].toString(),
          allData: successStatus,
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return SearchFriendResponse(
        // successStatus: 'Server Issue',
        // message: 'Server Issue'.toString(),
        allData: 'Server Issue'.toString(),
      );
    }
  }
}
