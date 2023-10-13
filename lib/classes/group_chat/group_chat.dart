// ignore_for_file: avoid_print, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:pludin/classes/controllers/zego_group_audio/zego_group_audio.dart';
import 'package:pludin/classes/controllers/zego_video/zego_video.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

import '../controllers/database/database_helper.dart';
import '../header/utils.dart';
import 'group_chat_details/group_chat_details.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, this.chatDialogData});

  final chatDialogData;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  //
  late DataBase handler;
  //
  var strFriendLoader = '0';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserFirebaseId = '';
  var strloginUserImage = '';
  var strLoginUserDeviceToken = '';
  //
  var strScrollOnlyOneTime = '1';
  var lastMessage = '';
  //
  File? imageFile;
  var str_image_processing = '0';
  //
  var fetchChatMembers;
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //
  // audio call
  var save_members_details = [];
  var strGroupName = '';
  var strDisableTextField = '1';
  //
  var uuid = const Uuid().v4();
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('**************** CHAT DATA ***************************');
      print(widget.chatDialogData);
      print('**************** MATCH ***************************');
      print(widget.chatDialogData['match']);
      print('*******************************************************');
    }
    super.initState();
    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
    fetchChatMembers = widget.chatDialogData['match'];
    print(fetchChatMembers);
    //
    strGroupName = widget.chatDialogData['group_name'].toString();
    //
    // funcCheckMemberIsInGroupXMPP();
    funcGetMembersDataFromFirebase('group_voice');
    //
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
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
                for (int i = 0; i < value.length; i++)
                  {
                    strLoginUserId = value[i].userId.toString(),
                    strLoginUserName = value[i].fullName.toString(),
                    strLoginUserFirebaseId = value[i].firebaseId.toString(),
                    strloginUserImage = value[i].image.toString(),
                    strLoginUserDeviceToken = value[i].deviceToken.toString()
                    //
                  },
              });
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            (widget.chatDialogData['group_display_image'].toString() == '')
                ? Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: GestureDetector(
                          onTap: () {
                            // print('click 1');
                            //
                            pushToChatDetails(context);
                            //
                          },
                          child: Image.asset(
                            'assets/icons/avatar.png',
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        width: 5,
                      ),
                      //
                      textWithRegularStyle(
                        //
                        strGroupName,
                        //
                        Colors.white,
                        16.0,
                      )
                      //
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print('click 1');
                              //
                              pushToChatDetails(context);
                              //
                            },
                            child: Image.network(
                              widget.chatDialogData['group_display_image']
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        width: 10,
                      ),
                      //
                      textWithRegularStyle(
                        //
                        strGroupName,
                        //
                        Colors.white,
                        16.0,
                      )
                      //
                    ],
                  ),
          ],
        ),
        backgroundColor: navigationColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  // funcGetDeviceTokenFromXMPP('voice');
                  funcCallGroupAudioCall();
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(top: 0, bottom: 60),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('${strFirebaseMode}dialog')
                  .doc('India')
                  .collection('details')
                  .orderBy('time_stamp', descending: true)
                  .where('group_id',
                      isEqualTo: widget.chatDialogData['group_id'].toString())
                  .where('match', arrayContainsAny: [
                //
                FirebaseAuth.instance.currentUser!.uid,
                //
              ]).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (kDebugMode) {
                    print('=============== DIALOG DATA IN CHAT ==============');
                    print(snapshot);
                    print(snapshot.data!);
                    print(snapshot.data!.docs);
                    print(snapshot.data!.docs.length);
                    print('======================================');
                  }

                  var saveSnapshotValue = snapshot.data!.docs;
                  if (kDebugMode) {
                    print('=============== DIALOG ==============');
                    print(saveSnapshotValue);
                    print('======================================');
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    // setState(() {
                    strDisableTextField = '0';
                    // });
                  }
                  return (snapshot.data!.docs.isEmpty)
                      ? AlertDialog(
                          backgroundColor: Colors.redAccent,
                          title: textWithBoldStyle(
                            'Alert',
                            Colors.white,
                            18.0,
                          ),
                          content: textWithRegularStyle(
                            'You are no longer the member of this group. Please contact admin for more info.',
                            Colors.white,
                            14.0,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: textWithBoldStyle(
                                'Ok',
                                Colors.white,
                                18.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.grey,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(
                                        "${strFirebaseMode}message/${widget.chatDialogData['group_id'].toString()}/details",
                                      )
                                      .orderBy('time_stamp', descending: true)
                                      .limit(40)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (kDebugMode) {
                                        print('=====> YES, DATA');
                                      }
                                      //
                                      if (strScrollOnlyOneTime == '1') {
                                        _needsScroll = true;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                                (_) => _scrollToEnd());
                                      }
                                      //

                                      var getSnapShopValue =
                                          snapshot.data!.docs.reversed.toList();
                                      if (kDebugMode) {
                                        // print(getSnapShopValue);
                                      }
                                      return Stack(
                                        children: [
                                          if (strScrollOnlyOneTime == '1') ...[
                                            const SizedBox(
                                              height: 0,
                                            )
                                          ] else ...[
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: InkWell(
                                                onTap: () {
                                                  _needsScroll = true;
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) =>
                                                              _scrollToEnd());
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  width: 120,
                                                  height: 40,
                                                  child: Center(
                                                    child: textWithRegularStyle(
                                                      'str',
                                                      Colors.black,
                                                      14.0,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      250,
                                                      247,
                                                      247,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      14.0,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          ListView.builder(
                                            // controller: controller,
                                            controller: _scrollController,
                                            itemCount: getSnapShopValue.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                  //
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Align(
                                                    alignment: (getSnapShopValue[index][
                                                                    'sender_firebase_id']
                                                                .toString() ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? Alignment.topRight
                                                        : Alignment.topLeft),
                                                    child: (getSnapShopValue[index]
                                                                    [
                                                                    'sender_firebase_id']
                                                                .toString() ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        ? senderUI(
                                                            getSnapShopValue, index)
                                                        : receiverUI(
                                                            getSnapShopValue,
                                                            index) //receiverUI(getSnapShopValue, index),
                                                    ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      // return Center(
                                      //   child: Text(
                                      //     'Error: ${snapshot.error}',
                                      //   ),

                                      // );
                                      if (kDebugMode) {
                                        print(snapshot.error);
                                      }
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                            },
                          ),
                        );
                } else if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error);
                  }
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),

            /**/
          ),
          //
          // ======> SEND MESSAGE UI <======
          // ===============================
          (strDisableTextField == '0')
              ? const SizedBox(
                  height: 40,
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: sendMessageUI(),
                ),
          // ================================
          // ================================
          //
        ],
      ),
    );
  }

//
//  Column receiverUI() {
  Column receiverUI(getSnapshot, int index) {
    return Column(
      children: [
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyle(
            //
            getSnapshot[index]['sender_name'],
            //
            Colors.black,
            10.0,
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(
              right: 40,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  16,
                ),
                bottomRight: Radius.circular(
                  16,
                ),
                topRight: Radius.circular(
                  16,
                ),
              ),
              color: Colors.blue[200],
            ),
            padding: const EdgeInsets.all(
              16,
            ),
            child: textWithRegularStyle(
              //
              getSnapshot[index]['message'].toString(),
              //
              Colors.black,
              14.0,
            ),
            // textWithRegularStyle(
            //   getSnapshot[index]['message'].toString(),
            //   14.0,
            //   Colors.black,
            //   'left',
            // ),
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyle(
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            Colors.black,
            14.0,
          ),
          // textWithRegularStyle(

          //   12.0,
          //   Colors.black,
          //   'left',
          // ),
        ),
        //
      ],
    );
  }

// Column senderUI() {
  Column senderUI(getSnapshot, int index) {
    return Column(
      children: [
        //
        Align(
          alignment: Alignment.bottomRight,
          child: textWithRegularStyle(
            //
            getSnapshot[index]['sender_name'],
            //
            Colors.black,
            10.0,
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomRight,
          child: (getSnapshot[index]['message'].toString() == '')
              ? Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 240,
                  height: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                    child: Image.network(
                      getSnapshot[index]['attachment_path'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        16,
                      ),
                      bottomLeft: Radius.circular(
                        16,
                      ),
                      topRight: Radius.circular(
                        16,
                      ),
                    ),
                    color: Color.fromARGB(255, 228, 232, 235),
                  ),
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Text(
                    //
                    getSnapshot[index]['message'].toString(),
                    //
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
        ),
        //
        Align(
          alignment: Alignment.bottomRight,
          child: textWithRegularStyle(
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            Colors.black,
            10.0,
          ),
        ),
        //
      ],
    );
  }

  //
  //
  Container sendMessageUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromRGBO(
        246,
        248,
        253,
        1,
      ),
      // height: 60,
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  openGalleryOrCamera(context);
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.attachment,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contTextSendMessage,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  // labelText: '',
                  hintText: 'write something',
                ),
              ),
            ),
          ),
          //

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  (strDisableTextField == '0')
                      ? contTextSendMessage.text = ''
                      : sendMessageViaFirebase(contTextSendMessage.text);
                  lastMessage = contTextSendMessage.text.toString();
                  contTextSendMessage.text = '';
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('send');
              }
              //

              sendMessageViaFirebase(contTextSendMessage.text);
              lastMessage = contTextSendMessage.text.toString();
              contTextSendMessage.text = '';

              // }
            },
            icon: const Icon(
              Icons.send,
            ),
          ),*/
          //
        ],
      ),
    );
  }

  //
  // send message
  sendMessageViaFirebase(strLastMessageEntered) {
    // print(cont_txt_send_message.text);

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/${widget.chatDialogData['group_id'].toString()}/details',
    );

    users
        .add(
          {
            'attachment_path': '',
            'sender_image': strloginUserImage.toString(),
            'sender_name': strLoginUserName.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'message': strLastMessageEntered.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'group',
            'type': 'Text',
            'chat_members': fetchChatMembers,
          },
        )
        .then(
          (value) =>
              //
              funcEditMessageAndInsertFirestoreId(value.id),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

//
  funcEditMessageAndInsertFirestoreId(value2) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}message")
        .doc(widget.chatDialogData['group_id'].toString())
        .collection('details')
        .doc(value2)
        .set(
      {
        'firestore_id': value2.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) => funcUpdateDialog(value2),
    );
  }

  //
  funcUpdateDialog(elementId) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc('India')
        .collection('details')
        //.doc('07f4b2bb-3213-4e3d-85bc-e5645863036e')
        .where('group_id',
            isEqualTo: widget.chatDialogData['group_id'].toString())
        .get()
        .then(
          (value) => {
            if (value.docs.isEmpty)
              {
                if (kDebugMode)
                  {
                    print('======> NO USER FOUND'),
                  }
                // ADD THIS USER TO FIREBASE SERVER

                //
              }
            else
              {
                for (var element in value.docs)
                  {
                    // if (kDebugMode)
                    //   {
                    //     print(element.id),
                    //     print(element.id.runtimeType),
                    //   }
                    // EDIT USER IF IT ALREADY EXIST
                    funcEditDialog(element.id)
                    //
                  }
              }
          },
        );
  }

  //
  funcEditDialog(elementId) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .doc(elementId)
        .set(
      {
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'message': lastMessage.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) => print(''),
    );
  }

  //
  //
  void openGalleryOrCamera(BuildContext context) {
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
                  print('camera');
                  imageFile = File(pickedFile.path);
                });
                //
                str_image_processing = '1';
                //
                uploadImageToFirebase(context);
                //

                //
              }
            },
            child: Text(
              'Open Camera',
              // style: TextStyle(
              // fontFamily: font_family_name,
              // fontSize: 18.0,
              // ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('gallery');
                  }
                  imageFile = File(pickedFile.path);
                });
                str_image_processing = '1';
                uploadImageToFirebase(context);
              }
            },
            child: Text(
              'Open Gallery',
              // style: TextStyle(
              // fontFamily: font_family_name,
              // fontSize: 18.0,
              // ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              // style: TextStyle(
              //   fontFamily: font_family_name,
              //   fontSize: 18.0,
              // ),
            ),
          ),
        ],
      ),
    );
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
          'private_chat/${FirebaseAuth.instance.currentUser!.uid}',
        )
        .child(
          generateRandomString(10),
        );
    await storageRef.putFile(imageFile!);
    return await storageRef.getDownloadURL().then((value) => {
          // print(
          //   '======>$value',
          // )
          sendImagViaMessageForGroupChat(value)
        });
  }

  sendImagViaMessageForGroupChat(attachmentPath) {
    // print(cont_txt_send_message.text);

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/${widget.chatDialogData['group_id'].toString()}/details',
    );

    users
        .add(
          {
            'sender_image': strloginUserImage.toString(),
            'attachment_path': attachmentPath.toString(),
            'sender_name': strLoginUserName.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'message': ''.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'group',
            'type': 'Image',
            'chat_members': fetchChatMembers,
          },
        )
        .then(
          (value) =>
              //
              funcEditMessageAndInsertFirestoreId(value.id),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
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
  Future<void> pushToChatDetails(BuildContext context) async {
    //
    print('object 4321');
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChatDetailsScreen(
            dictGetDataForDetails: widget.chatDialogData,
          ),
        ));

    if (!mounted) return;
    //
    // if (result == 'from_email_setting') {
    print(result);
    setState(() {
      strGroupName = result;
    });
    funcGetLocalDBdata();
    // }
  }

  //
  funcCheckMemberIsInGroupXMPP() {
    print('DISHANT');
    StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('${strFirebaseMode}dialog')
            .doc('India')
            .collection('details')
            .orderBy('time_stamp', descending: true)
            .where('match', arrayContainsAny: [
          //
          FirebaseAuth.instance.currentUser!.uid,
          //
        ]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (kDebugMode) {
              print('=============== DIALOG DATA IN CHAT ==============');
              print(snapshot.data!.docs.length);
              print('==================================================');
            }

            var saveSnapshotValue = snapshot.data!.docs;
            if (kDebugMode) {
              print('=============== DIALOG ==============');
              print(saveSnapshotValue);
              print('======================================');
            }
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.error,
    //   text: 'message'.toString(),
    // );
  }

  funcRemoved() {
    // Navigator.pop(context);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'message'.toString(),
    );
    //
  }

  //
  funcGetMembersDataFromFirebase(call_type) {
    print("====> TRYING TO GET ALL MEMBER'S DATA");
    //
    save_members_details.clear();
    //
    var arr_chat_dialog = [];

    for (int i = 0; i < widget.chatDialogData['match'].length; i++) {
      print(widget.chatDialogData['match'][i]);
      FirebaseFirestore.instance
          .collection("${strFirebaseMode}member")
          .doc("India")
          .collection("details")
          .where("firebaseId",
              isEqualTo: widget.chatDialogData['match'][i].toString())
          .get()
          .then((value) {
        if (kDebugMode) {
          print(value.docs);
        }

        if (value.docs.isEmpty) {
          if (kDebugMode) {
            print('======> NO USER FOUND');
          }
          //
        } else {
          for (var element in value.docs) {
            if (kDebugMode) {
              print('======> YES,  USER FOUND <=======');
              print('*******************************************************');
              print('*******************************************************');
              print(element.data());
              print('*******************************************************');
              print('*******************************************************');
              // print(element.data()['firebaseId'].toString());
              // print(element.data()['device'].toString());
            }
            //
            save_members_details.add(element.data());

            //
            /* */
            //
          }
        }
      });
    }
    //

    //
  }

  //
  funcCallGroupAudioCall() {
    print(save_members_details);
    print('========= MY DEVICE TOKEN =============');
    print(strLoginUserDeviceToken);
    print('=======================================');
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('Please wait...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //
    // create an array to save device and device token
    var arr_device_and_token = [];
    //
    for (int i = 0; i < save_members_details.length; i++) {
      var customJsonArray = {
        'device': save_members_details[i]['device'].toString(),
        'deviceToken': save_members_details[i]['deviceToken'].toString(),
      };
      if (strLoginUserFirebaseId !=
          save_members_details[i]['firebaseId'].toString()) {
        arr_device_and_token.add(customJsonArray);
      }
    }
    //
    print('============================');
    print(arr_device_and_token);
    print('============================');
    String encoded = jsonEncode(arr_device_and_token);
    //
    funcSendNotification(encoded, 'groupVoiceCall');
    //
  }

  //
  funcSendNotification(jsonData, type) async {
    // upload feeds data to time line
    //
    if (kDebugMode) {
      print('=====> POST : SEND NOTIFICATION <===== ');
      print(type);
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'action': 'groupsentnotification',
          'message': 'Incoming Group Audio Call',
          // (type == 'voice') ? 'Incoming Audio Call' : 'Imcoming Video Call',
          'userId': strLoginUserFirebaseId.toString(),
          'name': strLoginUserName.toString(),
          'image': strloginUserImage.toString(),
          'deviceJson': jsonData,
          'type': type, //(type == 'voice') ? 'audioCall' : 'videoCall',
          'channelName': uuid.toString(),
        },
      ),
    );

    // convert data to dict
    var data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(data);
    }

    if (resposne.statusCode == 200) {
      if (data['status'].toString().toLowerCase() == 'success') {
        //
        // Navigator.pop(context);

        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZegoGroupAudioScreen(
              channelName: uuid.toString(),
              userIdIs: strLoginUserFirebaseId.toString(),
              userName: strLoginUserName.toString(),
            ),
          ),
        );*/
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
