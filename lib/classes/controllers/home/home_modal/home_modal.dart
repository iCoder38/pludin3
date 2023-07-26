// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;

class HomeResponse {
  final allData;

  const HomeResponse({this.allData});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      allData: json,
    );
  }
}

class HomeModal {
  homeWB(
    String userId,
    String strProfileStatus,
    int pageNumber,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // print('DISHANT RAJPUT GET TIME FORMATT start');
    // print(formattedDate);

    final response = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'action': 'home',
          'userId': userId,
          'type': strProfileStatus.toString(),
          'pageNo': pageNumber,
          // 'created': formattedDate,
        },
      ),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('==========> 200');
        // print(response.body);
      }

      // =====> response.body

      var getData = jsonDecode(response.body);
      if (kDebugMode) {
        print(getData);

        // print(getData.runtimeType);
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
        return HomeResponse(
          allData: successStatus,
        );
      }
    } else {
      if (kDebugMode) {
        print("============> ERROR");
      }
      return HomeResponse(
        allData: 'Server Issue'.toString(),
      );
    }
  }
}
