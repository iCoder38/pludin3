import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/custom_files/app_bar/appbar.dart';
// import 'package:triple_r_custom/custom_files/drawer/drawer.dart';

import 'package:http/http.dart' as http;
import 'package:pludin/classes/header/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/drawer/drawer.dart';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// import 'package:flutter_email_sender/flutter_email_sender.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  //
  //

  var str_phone = 'please wait...';
  var str_email = 'please wait...';
  //
  //

  @override
  void initState() {
    super.initState();
    get_help_WB();
  }

  // get help
  get_help_WB() async {
    print('=====> GET CART');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getInt('userId').toString());
    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'help',
        },
      ),
    );

// convert data to dict
    var get_data = jsonDecode(resposne.body);
    print(get_data);
    // print(get_data['data'][0]['id']);
    if (resposne.statusCode == 200) {
      ///
      ///
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        str_email = get_data['data']['eamil'].toString();
        str_phone = get_data['data']['phone'].toString();
        //
        setState(() {});
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithBoldStyle(
          'Help',
          Colors.white,
          18.0,
        ),
        backgroundColor: navigationColor,
      ),
      // appBar: const PreferredSize(
      // preferredSize: Size.fromHeight(50),
      // child: AppBarCustom(
      //   navigation_title: 'Help',
      // ),
      // ),

      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          image: DecorationImage(
            image: AssetImage(
              'assets/images/Background@3x.png',
            ),
            fit: BoxFit.fill,
          ),
          // shape: BoxShape.circle,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: 260,
                width: 260,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage(
                      // image name
                      'assets/images/logo.png',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: textWithRegularStyle(
                            'CONNECT WITH US :',
                            Colors.white,
                            14.0,
                          ),
                        ),
                        //height: 20,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          //
                          _sendingMails();
                          //
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: textWithBoldStyle(
                              //
                              str_email.toString(),
                              //
                              Colors.white,
                              18.0,
                            ),
                          ),
                          //height: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          // FlutterPhoneDirectCaller.callNumber(
                          // str_phone.toString(),
                          // );
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: textWithBoldStyle(
                              //
                              str_phone.toString(),
                              //
                              Colors.white,
                              18.0,
                            ),
                          ),
                          //height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: textWithBoldStyle(
                      '@ 2023 Pludin. All Rights Reserved.',
                      Colors.white,
                      16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendingMails() async {
    // var url = Uri.parse("mailto:$str_email");
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}
