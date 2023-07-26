// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// import 'package:triple_r_custom/Utils.dart';

// import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Album {
  final String success_status;
  final String message;
  // final String ;

  const Album({required this.success_status, required this.message});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      success_status: json['status'],
      message: json['msg'],
    );
  }
}

class ChangePasswordModal {
  update_password_WB(
    String userId,
    String old_password,
    String new_password,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'changepassword',
          'userId': userId.toString(),
          'newPassword': new_password,
          'oldPassword': old_password,
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      print('=========> 201');
      print(response.body);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      print("<==============================>");
      print("<==============================>");
      print('==========> 200');
      print(response.body);
      print("<==============================>");
      print("<==============================>");

      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      //  print(response.body);
      print("<==============================>");
      print("<==============================>");
      // convert data to dict
      // Map<String, dynamic> get_data = jsonDecode(response.body);

      // get data from server key : if any
      // Map<String, dynamic> user = get_data['data'];
      // print(user);

      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('login_user_id', user['userId']);
      prefs.setString('login_user_name', user['name']);*/

      print("<==============================>");
      print("<==============================>");
      Map<String, dynamic> success_status = jsonDecode(response.body);
      // print(" User name ${success_status['status']}");
      // convert success to lower case
      var success_text = success_status['status'].toString().toLowerCase();

      // after SUCCESS
      if (success_text == "success") {
        print('=========> USER SUCCESSFULLY REGISTERED <===========');
        return Album(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      } else {
        print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        return Album(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      }
      // throw Exception('SOMETHING WENT WRONG. PLEASE CHECK');
    } else {
      print("============> ERROR");
      print(response.body);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
