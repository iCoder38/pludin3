// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

import '../controllers/database/database_helper.dart';
import '../controllers/my_friends/my_friends_modal/my_friends_modal.dart';
import '../header/utils.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  //
  var strFriendLoader = '0';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserFirebaseId = '';
  var strloginUserImage = '';
  var arrSearchFriend = [];
  late DataBase handler;
  final friendApiCall = FriendModal();
  //
  var strFriendsList = '0';
  //
  var arrFriends = [];
  //
  late final TextEditingController contEmail;
  //
  var strCheckmark = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  var strProfilImageLoader = '0';
  var strGetUploadImageURL = '';
  //
  @override
  void initState() {
    //

    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
    contEmail = TextEditingController();
    //
    super.initState();
  }

  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
        // if (kDebugMode) {
        //   print(value);
        //   print(value.length);
        // }
        if (value.isEmpty) {
          if (kDebugMode) {
            print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
          }
          // call firebase server
        } else {
          if (kDebugMode) {
            print('YES, LOCAL DB HAVE SOME DATA');
          }
          //

          handler.retrievePlanetsById(1).then((value) => {
                print(value),
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    strLoginUserName = value[i].fullName.toString(),
                    strLoginUserFirebaseId = value[i].firebaseId.toString(),
                    strloginUserImage = value[i].image.toString(),
                    // print('dishant rajput 1.1 ====> $strLoginUserId'),
                    // print(widget.strUserId),
                    //
                  },
                //
                // HIT WEBSERVICE TO SEARCH FRIEND
                friendApiCall
                    .friendsWB(
                      strLoginUserId.toString(),
                      '2',
                    )
                    .then((value) => {
                          //
                          arrSearchFriend = value,
                          funcCreateCustomFriendListWB(),
                          //
                        }),
                //
                //
              });
        }
      },
    );
    //
  }

  funcCreateCustomFriendListWB() {
    for (int i = 0; i < arrSearchFriend.length; i++) {
      var customDict = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'no'
      };

      arrFriends.add(customDict);
    }

    if (kDebugMode) {
      print(arrSearchFriend.length);
      print('custom friends list');
      print(arrFriends);
    }

    setState(() {
      strFriendLoader = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Create group',
          Colors.white,
          16.0,
        ),
        backgroundColor: navigationColor,
        actions: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('object');
              }
              //
              funcCreateGroup();
              //
            },
            icon: const Icon(
              Icons.check,
              size: 28.0,
            ),
          ),
        ],
      ),
      body: (strFriendLoader == '0')
          ? Center(
              child: CircularProgressIndicator(
                color: navigationColor,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  //
                  headerUI(context),
                  //
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: textWithBoldStyle(
                      ' Friends',
                      Colors.black,
                      22.0,
                    ),
                  ),
                  //
                  (strFriendsList == '0')
                      ? const SizedBox(
                          width: 0,
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              for (int i = 0; i < arrFriends.length; i++) ...[
                                //
                                if (arrFriends[i]['status'] == 'yes') ...[
                                  Container(
                                    height: 40,
                                    // width: 80,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            child: (strLoginUserId ==
                                                    arrFriends[i]['userId']
                                                        .toString())
                                                ? (arrFriends[i][
                                                                'FirstUserimage']
                                                            .toString() ==
                                                        '')
                                                    ? Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                            246,
                                                            248,
                                                            253,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                          image:
                                                              const DecorationImage(
                                                            image: AssetImage(
                                                              'assets/icons/avatar.png',
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                            246,
                                                            248,
                                                            253,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                          child: Image.network(
                                                            //
                                                            arrFriends[i][
                                                                    'FirstUserimage']
                                                                .toString(),
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            //
                                                          ),
                                                        ),
                                                      )
                                                : (arrFriends[i][
                                                                'SecondUserimage']
                                                            .toString() ==
                                                        '')
                                                    ? Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                            246,
                                                            248,
                                                            253,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                          image:
                                                              const DecorationImage(
                                                            image: AssetImage(
                                                              'assets/icons/avatar.png',
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                            246,
                                                            248,
                                                            253,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            30,
                                                          ),
                                                          child: Image.network(
                                                            //
                                                            arrFriends[i][
                                                                    'SecondUserimage']
                                                                .toString(),
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            //
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                        ),
                                        //
                                        (strLoginUserId ==
                                                arrFriends[i]['userId']
                                                    .toString())
                                            ? textWithBoldStyle(
                                                //
                                                ' ' +
                                                    arrFriends[i]
                                                            ['FirstfullName']
                                                        .toString(),
                                                // '12',
                                                //
                                                Colors.black,
                                                16.0,
                                              )
                                            : textWithBoldStyle(
                                                //
                                                ' ' +
                                                    arrFriends[i]
                                                            ['SecondfullName']
                                                        .toString(),
                                                // '12',
                                                //
                                                Colors.black,
                                                16.0,
                                              ),

                                        const SizedBox(
                                          width: 10,
                                        ),
                                        //
                                      ],
                                    ),
                                  ),
                                ],
                                //
                              ]
                            ],
                          ),
                        ),
                  //
                  const SizedBox(
                    height: 6,
                  ),
                  for (int i = 0; i < arrFriends.length; i++) ...[
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(
                        246,
                        248,
                        253,
                        1,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              width: 40,
                              height: 40,
                              child: (strLoginUserId ==
                                      arrFriends[i]['userId'].toString())
                                  ? (arrFriends[i]['FirstUserimage']
                                              .toString() ==
                                          '')
                                      ? Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              246,
                                              248,
                                              253,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/icons/avatar.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              246,
                                              248,
                                              253,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: Image.network(
                                              //
                                              arrFriends[i]['FirstUserimage']
                                                  .toString(),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              //
                                            ),
                                          ),
                                        )
                                  : (arrFriends[i]['SecondUserimage']
                                              .toString() ==
                                          '')
                                      ? Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              246,
                                              248,
                                              253,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/icons/avatar.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              246,
                                              248,
                                              253,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: Image.network(
                                              //
                                              arrFriends[i]['SecondUserimage']
                                                  .toString(),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              //
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                          //
                          Expanded(
                            child: (strLoginUserId ==
                                    arrFriends[i]['userId'].toString())
                                ? textWithRegularStyle(
                                    ' ${arrFriends[i]['FirstfullName']}',
                                    Colors.black,
                                    14.0,
                                  )
                                : textWithRegularStyle(
                                    ' ${arrFriends[i]['FirstfullName']}',
                                    Colors.black,
                                    14.0,
                                  ),
                          ),
                          //
                          InkWell(
                            onTap: () {
                              //
                              funcAdOrRemoveFriends(i);
                              //
                            },
                            child: (arrFriends[i]['status'].toString() == 'no')
                                ? Container(
                                    margin: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    height: 36,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(
                                        18.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: textWithRegularStyle(
                                        'Add',
                                        Colors.black,
                                        14.0,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    height: 36,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(
                                        18.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: textWithRegularStyle(
                                        'Remove',
                                        Colors.white,
                                        12.0,
                                      ),
                                    ),
                                  ),
                          ),
                          //
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }

  Container headerUI(BuildContext context) {
    return Container(
      // height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(
          246,
          248,
          253,
          1,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              //
              openCameraAndGaleeryPopUP(context);
              //
            },
            child: (imageFile == null)
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      bottom: 20.0,
                      top: 20.0,
                    ),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(
                        40.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffDDDDDD),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/avatar.png',
                    ),
                  )
                : (strProfilImageLoader == '1')
                    ? Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 20.0,
                          top: 20.0,
                        ),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 6.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              40.0,
                            ),
                            child: CircularProgressIndicator()),
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 20.0,
                          top: 20.0,
                        ),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 6.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          child: Image.file(
                            fit: BoxFit.cover,
                            imageFile!,
                          ),
                        ),
                      ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 10.0,
                right: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30,
                ),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffDDDDDD),
                    blurRadius: 6.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextFormField(
                  controller: contEmail,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  // controller: contGrindCategory,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Group name',
                  ),
                  onTap: () {
                    // category_list_POPUP('str_message');
                  },
                  // validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  funcAdOrRemoveFriends(i) {
    //
    if (kDebugMode) {
      print(i);
      print(arrFriends[i]);
    }

    if (arrFriends[i]['status'] == 'no') {
      var custom = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'yes'
      };
      //
      arrFriends.removeAt(i); // remove
      arrFriends.insert(i, custom); // insert
      //
    } else {
      var custom = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'no'
      };
      //
      arrFriends.removeAt(i); // remove
      arrFriends.insert(i, custom); // insert
      //
    }

    setState(() {
      for (int i = 0; i < arrFriends.length; i++) {
        if (arrFriends[i]['status'] == 'yes') {
          strFriendsList = '1';
          return;
        } else {
          strFriendsList = '0';
        }

        //
      }
    });
    //
  }

  //
  //
  void openCameraAndGaleeryPopUP(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  imageFile = File(pickedFile.path);
                });
              }
            },
            child: textWithRegularStyle(
              'Open Camera',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //

              //
              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('object');
                  }

                  //
                  imageFile = File(pickedFile.path);
                  //
                  strProfilImageLoader = '1';
                  uploadImageToFirebase(context);
                  //
                });
              }
            },
            child: textWithRegularStyle(
              'Open Gallery',
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
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  funcCreateGroup() {
    if (kDebugMode) {
      print('object');
      print(strFriendsList);
    }
    //
    if (strFriendsList == '0') {
      //
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Please select atleast one friend'.toString(),
      );
      //
    } else if (contEmail.text == '') {
      //
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Please enter group name'.toString(),
      );
      //
    } else {
      if (kDebugMode) {
        print('object 1');
      }
      //
      funcCreateGroupChatInXMPP();
      //
    }
    //
  }

  //
  funcCreateGroupChatInXMPP() {
    //
    // var snackBar = SnackBar(
    //   backgroundColor: navigationColor,
    //   content: const Text('Creating....'),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    var groupIdCreate = const Uuid().v4();
    var arrMatch = [];
    //
    if (kDebugMode) {
      // print(arrFriends);
    }
    //
    arrMatch.add(FirebaseAuth.instance.currentUser!.uid);
    //
    for (int i = 0; i < arrFriends.length; i++) {
      if (arrFriends[i]['status'] == 'yes') {
        arrMatch.add(arrFriends[i]['friendFirebaseId'].toString());
      }
    }
    if (kDebugMode) {
      print(arrMatch);
    }
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}dialog/India/details',
    );

    users
        .add(
          {
            //
            'deviceToken': '',
            'receiver_firebase_id': '',
            'receiver_image': '',
            'receiver_name': '',
            'sender_firebase_id': '',
            'sender_image': '',
            'sender_name': '',
            'users': [],
            //
            'group_id': groupIdCreate.toString(),
            'group_name': contEmail.text.toString(),
            'group_display_image': strGetUploadImageURL.toString(),
            'chat_type': 'group',
            'message': 'new group created',
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'match': arrMatch,
          },
        )
        .then(
          (value) => funcSetMembersInGroup(value.id),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  //
  funcSetMembersInGroup(groupId) {
    if (kDebugMode) {
      print('================================');
      print(arrFriends);
      print('================================');
      print(arrFriends.length);
      print('================================');
      // print(arrSearchFriend);
      print('================================');
    }

    var arrMatch = [];

    var custom = {
      'evs_id': strLoginUserId.toString(),
      'name': strLoginUserName.toString(),
      'firebase_id': FirebaseAuth.instance.currentUser!.uid,
      'profile_picture': strloginUserImage.toString(),
      'type': 'Admin',
      'active': 'yes'
    };
    arrMatch.add(custom);

    for (int i = 0; i < arrFriends.length; i++) {
      if (arrFriends[i]['status'] == 'yes') {
        //
        //
        // print('================================');
        // print('================================');
        // print(i);
        // print('================================');
        // print('================================');

        var custom = {
          'evs_id': (strLoginUserId == arrFriends[i]['userId'].toString())
              ? arrFriends[i]['profileId'].toString()
              : arrFriends[i]['userId'].toString(),
          'name': (strLoginUserId == arrFriends[i]['userId'].toString())
              ? arrFriends[i]['FirstfullName'].toString()
              : arrFriends[i]['SecondfullName'].toString(),
          'firebase_id': arrFriends[i]['friendFirebaseId'].toString(),
          'profile_picture':
              (strLoginUserId == arrFriends[i]['userId'].toString())
                  ? arrFriends[i]['FirstUserimage'].toString()
                  : arrFriends[i]['SecondUserimage'].toString(),
          'type': 'member',
          'active': 'yes'
        };
        //
        arrMatch.add(custom);
        //
        FirebaseFirestore.instance
            .collection("${strFirebaseMode}dialog")
            .doc('India')
            .collection('details')
            .doc(groupId)
            .set(
          {
            'members_details': arrMatch,
          },
          SetOptions(merge: true),
        ).then(
          (value1) {
            //

            //
          },
        );
      }
    }
    //
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('Created....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  //
  // upload image via firebase
  Future uploadImageToFirebase(BuildContext context) async {
    if (kDebugMode) {
      print('dishu');
    }
    // String fileName = basename(imageFile_for_profile!.path);
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(
          'group_chat_profile_display_image/${FirebaseAuth.instance.currentUser!.uid}',
        )
        .child(
          generateRandomString(10),
        );
    await storageRef.putFile(imageFile!);
    return await storageRef.getDownloadURL().then((value) => {
          print(
            '======>$value',
          ),
          // sendImageViaFirebase(value)

          setState(() {
            strProfilImageLoader = '2';
            strGetUploadImageURL = value;
          }),
        });
  }

  //
  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }
  //
}
