// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen(
      {super.key, this.getPrivacyData, required this.strLoginUserId});

  final String strLoginUserId;
  final getPrivacyData;

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  //
  // String dropdownValue = 'Nobody';
  //
  var strPrivacyChange = '0';
  //
  var arrData = [];
  //
  var arrDropdownData = [
    'Nobody',
    'Nobody',
    'Nobody',
    'Nobody',
  ];
  //
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  String dropdownValue = 'One';
  //
  var strViewMyProfile = '';
  var strViewMyPost = '';
  var strViewYourFriend = '';
  var strViewProfilePricture = '';
  //
  @override
  void initState() {
    if (kDebugMode) {
      print(widget.getPrivacyData);
      print(widget.getPrivacyData.length);
    }

    if (widget.getPrivacyData.length == 0) {
      if (kDebugMode) {
        print('empty data');
      }
      //
      arrData = [
        {
          'title': 'Who can view your profile?',
          'drop_down': 'Everyone',
        },
        {
          'title': 'Who can view your posts?',
          'drop_down': 'Everyone',
        },
        /*{
          'title': 'Who can view your Friends?',
          'drop_down': 'Everyone',
        },*/
        {
          'title': 'Who can view profile picture?',
          'drop_down': 'Everyone',
        }
      ];
      //
    } else {
      if (kDebugMode) {
        print('yes some data');
      }

      funcUpdatePrivacySetting();
    }

    // if (widget.getPrivacyData) {
    //   print('object');
    // }

    super.initState();
  }

  funcUpdatePrivacySetting() {
    // who can view your profile
    var strProfilePrivacy = widget.getPrivacyData['profilePrivacy'].toString();

    if (strProfilePrivacy == '1') {
      strViewMyProfile = 'Everyone';
    } else if (strProfilePrivacy == '2') {
      strViewMyProfile = 'Friends';
    } else {
      strViewMyProfile = 'Only me';
    }

    // who can view your post
    var strViewYourPost = widget.getPrivacyData['PostPrivacy'].toString();

    if (strViewYourPost == '1') {
      strViewMyPost = 'Everyone';
    } else if (strViewYourPost == '2') {
      strViewMyPost = 'Friends';
    } else {
      strViewMyPost = 'Only me';
    }

    /*// who can view your friends
    var strViewYourFriends = widget.getPrivacyData['FriendPrivacy'].toString();

    if (strViewYourFriends == '1') {
      strViewYourFriend = 'Everyone';
    } else if (strViewYourFriends == '2') {
      strViewYourFriend = 'Friends';
    } else {
      strViewYourFriend = 'Only me';
    }*/

    // who can view your picture
    var strViewYourPicture =
        widget.getPrivacyData['Porfile_Image_Privacy'].toString();

    if (strViewYourPicture == '1') {
      strViewProfilePricture = 'Everyone';
    } else if (strViewYourPicture == '2') {
      strViewProfilePricture = 'Friends';
    } else {
      strViewProfilePricture = 'Only me';
    }

    arrData = [
      {
        'title': 'Who can view your profile?',
        'drop_down': strViewMyProfile.toString(),
      },
      {
        'title': 'Who can view your posts?',
        'drop_down': strViewMyPost.toString(),
      },
      /*{
        'title': 'Who can view your Friends?',
        'drop_down': strViewYourFriend.toString(),
      },*/
      {
        'title': 'Who can view profile picture?',
        'drop_down': strViewProfilePricture.toString(),
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Privacy Settings',
          Colors.white,
          20.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'from_privacy_setting');
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        backgroundColor: navigationColor,
        actions: [
          (strPrivacyChange == '0')
              ? const SizedBox(
                  height: 0,
                )
              : IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('object');
                    }
                    //
                    // openCameraAndGalleryPopUP(context);
                    //
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: arrData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: textWithBoldStyle(
                    //
                    arrData[index]['title'].toString(),
                    //
                    Colors.black,
                    16.0,
                  ),
                  trailing: InkWell(
                    onTap: () {
                      //
                      funcUpdateThatCell(index);
                      //
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 110,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: appBlueColor,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWithRegularStyle(
                            //
                            arrData[index]['drop_down'].toString(),
                            //
                            Colors.white,
                            14.0,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18.0,
                            color: Colors.white,
                          )
                          /*
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            dropdownColor: Colors.black,
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                if (kDebugMode) {
                                  print(index);
                                  print(value);
                                }
                  
                                dropdownValue = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          )*/
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            //
          ],
        ),
      ),
    );
  }

//
//
  funcUpdateThatCell(i) {
    if (kDebugMode) {
      // print('index number =====> ' + i);
    }
    //
    openCameraAndGaleeryPopUP(context, i);
    //
  }

//
  void openCameraAndGaleeryPopUP(BuildContext context, i) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: textWithBoldStyle(
          //
          arrData[i]['title'].toString(),
          //
          Colors.black,
          14.0,
        ),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              funcEditCustomArray('Everyone', i);
              //
              funcUploadDataWithOnlyText('1', i);
              //
            },
            child: textWithRegularStyle(
              'Everyone',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              funcEditCustomArray('Friends', i);
              //
              funcUploadDataWithOnlyText('2', i);
            },
            child: textWithRegularStyle(
              'Friends',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              funcEditCustomArray('Only me', i);
              //
              funcUploadDataWithOnlyText('3', i);
            },
            child: textWithRegularStyle(
              'Only me',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.red,
              18.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  funcEditCustomArray(newDropDownTitle, indexIs) {
    if (kDebugMode) {
      print(indexIs);
      print(arrData[indexIs]['title']);
    }
    //
    strPrivacyChange = '0';
    //
    var customData = {
      'title': arrData[indexIs]['title'].toString(),
      'drop_down': newDropDownTitle.toString(),
    };

    arrData.removeAt(indexIs);
    arrData.insert(indexIs, customData);

    // print(arrData);
    setState(() {});
  }

  //
  funcUploadDataWithOnlyText(
    // keyIs,
    valueIs,
    indexIs,
  ) async {
    //
    //
    QuickAlert.show(
      context: context,
      // backgroundColor: white,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'updating...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    setState(() {
      // strPostType = 'loader';
    });
    //
    if (kDebugMode) {
      print('=====> POST : UPDATE PRIVACY');
      print(valueIs);
      print(indexIs);
      print(arrData[indexIs]);
    }

    // profilePrivacy
    // PostPrivacy
    // FriendPrivacy

    var key = '';
    var value = '';

    if (indexIs.toString() == '0') {
      //
      key = 'profilePrivacy';
      value = valueIs.toString();
      //
    } else if (indexIs.toString() == '1') {
      //
      key = 'PostPrivacy';
      value = valueIs.toString();
      //
    } /* else if (indexIs.toString() == '2') {
      //
      key = 'FriendPrivacy';
      value = valueIs.toString();
      //
    } */
    else {
      //
      key = 'Porfile_Image_Privacy';
      value = valueIs.toString();
      //
    }

    if (kDebugMode) {
      print(key);
      print(value);
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'setting',
          'userId': widget.strLoginUserId.toString(),
          key: value,
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        Navigator.pop(context);
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }
}
