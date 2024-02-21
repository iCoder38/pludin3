// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../database/database_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeLikeResponse {
  final allData;
  // final String ;

  const HomeLikeResponse({this.allData});

  factory HomeLikeResponse.fromJson(Map<String, dynamic> json) {
    return HomeLikeResponse(
      allData: json,
    );
  }
}

class HomeLikeModal {
  homeLikeUnlikeWB(
    String userId,
    String postId,
    String status,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      /*
      action:addlike
userId:2
postId:2
status:// 1=Like 0=Unlike
      */
      body: jsonEncode(
        <String, String>{
          'action': 'addlike',
          'userId': userId,
          'postId': postId.toString(),
          'status': status.toString()
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

      if (kDebugMode) {
        // print(getData2);
        // print(getData2.runtimeType);
        print('=========> ok2 ok2  <===========');
      }

      if (kDebugMode) {
        print('rajput ==========> 200');
      }

      var successText = successStatus['status'].toString().toLowerCase();

      // after SUCCESS
      if (successText == "success") {
        if (kDebugMode) {
          print('=========> HOME SUCCESS <===========');
        }

        var getData = jsonDecode(response.body);
        if (kDebugMode) {
          print(getData);
          // print(getData.runtimeType);
        }
        /*var arr = [];
        for (Map i in getData['data']) {
          arr.add(i);
        }*/
        // print('check =======> $arr');
        // print('check count =======> ${arr.length}');
        // return HomeResponse(allData: arr.toString());
        return getData;
      } else {
        if (kDebugMode) {
          print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        }
        return HomeLikeResponse(
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
      return HomeLikeResponse(
        // successStatus: 'Server Issue',
        // message: 'Server Issue'.toString(),
        allData: 'Server Issue'.toString(),
      );
    }
  }
}
