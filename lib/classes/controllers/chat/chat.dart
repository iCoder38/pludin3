import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:pludin/classes/controllers/chat_audio_call/chat_audio_call.dart';
// import 'package:pludin/classes/custom/app_bar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pludin/classes/chat_video_call/video_call.dart';

import '../../header/utils.dart';
import '../database/database_helper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, this.chatDialogData, required this.strFromDialog});

  final chatDialogData;
  final String strFromDialog;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //
  File? imageFile;
  var str_image_processing = '0';
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //
  var strScrollOnlyOneTime = '1';
  var lastMessage = '';
  //
  var roomId = '';
  var reverseRoomId = '';
  //
  late DataBase handler;
  //
  var strLoginUserName = '';
  var strLoginUserImage = '';
  //
  var strReceiverId = '';
  var strReceiverName = '';
  var strReceiverImage = '';
  var strReceiverFirebaseId = '';
  //
  var strNavigationTitle = '';
  //
  @override
  void initState() {
    super.initState();
    //
    handler = DataBase();
    //
    if (kDebugMode) {
      print(widget.chatDialogData);
    }

    funcGetLocalDBdata();

    if (widget.strFromDialog == 'yes') {
      //
      print('yes from dialog');
      if (FirebaseAuth.instance.currentUser!.uid ==
          widget.chatDialogData['sender_firebase_id'].toString()) {
        //

        strNavigationTitle = widget.chatDialogData['receiver_name'].toString();
        //
        // strReceiverId = widget.chatDialogData['sender_name'].toString();
        strReceiverName = widget.chatDialogData['receiver_name'].toString();
        strReceiverImage = widget.chatDialogData['receiver_image'].toString();
        strReceiverFirebaseId =
            widget.chatDialogData['receiver_firebase_id'].toString();
        //
      } else {
        //
        strNavigationTitle = widget.chatDialogData['sender_name'].toString();
        //
        // strReceiverId = widget.chatDialogData['sender_name'].toString();
        strReceiverName = widget.chatDialogData['sender_name'].toString();
        strReceiverImage = widget.chatDialogData['sender_image'].toString();
        strReceiverFirebaseId =
            widget.chatDialogData['sender_firebase_id'].toString();
        //
      }

      //
      roomId =
          '${widget.chatDialogData['receiver_firebase_id'].toString()}+${widget.chatDialogData['sender_firebase_id'].toString()}';
      reverseRoomId =
          '${widget.chatDialogData['sender_firebase_id'].toString()}+${widget.chatDialogData['receiver_firebase_id'].toString()}';
    } else {
      //

      strNavigationTitle = widget.chatDialogData['fullName'].toString();

      //
      roomId =
          '${FirebaseAuth.instance.currentUser!.uid}+${widget.chatDialogData['firebaseId'].toString()}';
      reverseRoomId =
          '${widget.chatDialogData['firebaseId'].toString()}+${FirebaseAuth.instance.currentUser!.uid}';
    }

    //
    if (kDebugMode) {
      print('room id ======> $roomId');
      print('reverse room id =====> $reverseRoomId');
    }
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
                    strLoginUserName = value[i].fullName.toString(),
                    strLoginUserImage = value[i].image.toString(),
                    // print(strLoginUserImage),
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
        title: textWithRegularStyle(
          // (widget.chatDialogData['sender_id'])
          strNavigationTitle.toString(),
          Colors.white,
          20.0,
        ),
        backgroundColor: navigationColor,
        actions: [
          // as
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatAudioCallScreen(
                        getAllData: widget.chatDialogData,
                        strGetCallStatus: 'make_call',
                      ),
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                        getAllData: widget.chatDialogData,
                        strGetCallStatus: 'make_call',
                      ),
                    ),
                  );
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_call,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
          /*IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('object');
              }
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAudioCallScreen(
                    getAllData: widget.chatDialogData,
                    strGetCallStatus: 'make_call',
                  ),
                ),
              );
              //
            },
            icon: const Icon(
              Icons.phone,
            ),
          )*/
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // keyboard dismiss when click outside
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 0, bottom: 60),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                        "${strFirebaseMode}message/India/private_chats",
                      )
                      .orderBy('time_stamp', descending: true)
                      .where(
                        'room_id',
                        whereIn: [
                          roomId,
                          reverseRoomId,
                        ],
                      )
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
                            .addPostFrameCallback((_) => _scrollToEnd());
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
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _scrollToEnd());
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
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
                                    borderRadius: BorderRadius.circular(
                                      14.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
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
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            physics: const BouncingScrollPhysics(),
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
                                  alignment: (getSnapShopValue[index]
                                                  ['sender_firebase_id']
                                              .toString() ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                                  child: (getSnapShopValue[index]
                                                  ['sender_firebase_id']
                                              .toString() ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? senderUI(getSnapShopValue, index)
                                      : receiverUI(getSnapShopValue, index),
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
                  }),
            ),
            //
            // ======> SEND MESSAGE UI <======
            // ===============================
            Align(
              alignment: Alignment.bottomCenter,
              child: sendMessageUI(),
            ),
            // ================================
            // ================================
            //
            (str_image_processing == '1')
                ? Container(
                    // margin: const EdgeInsets.all(10.0),
                    color: const Color.fromRGBO(
                      246,
                      248,
                      253,
                      1,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 48.0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: navigationColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          textWithRegularStyle(
                            'processing...',
                            Colors.black,
                            14.0,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  //
//  Column receiverUI() {
  Column receiverUI(getSnapshot, int index) {
    return Column(
      children: [
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
                : textWithRegularStyle(
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

  //
  // Column senderUI() {
  Column senderUI(getSnapshot, int index) {
    return Column(
      children: [
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
            14.0,
          ),
        ),
        //
      ],
    );
  }

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
                  // print('me print');
                  sendMessageViaFirebase(contTextSendMessage.text);
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
      '${strFirebaseMode}message/India/private_chats',
    );

    /*
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print('SENDER RECEIVER FID =====>${widget.strReceiverFirebaseId}');
      print('SENDER RECEIVER CHAT ID =====>${widget.strReceiverChatId}');
    }
    */

    users
        .add(
          {
            'attachment_path': '',
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_name': strLoginUserName.toString(),
            // 'receiver_name': strReceiverName.toString(),
            'receiver_firebase_id': strReceiverFirebaseId.toString(),

            'message': strLastMessageEntered.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'private',
            'type': 'Text',

            'sender_image': strLoginUserImage.toString(),
            // 'receiver_image': strReceiverImage.toString(),

            // save room id
            'room_id': roomId.toString(),
            'users': [
              roomId,
              reverseRoomId,
            ]
          },
        )
        .then(
          (value) =>
              //
              // print('==>${FirebaseAuth.instance.currentUser!.uid}'),

              funcCheckUsersIsAlreadyChatWithEachOther(),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  //
  funcCheckUsersIsAlreadyChatWithEachOther() {
    if (kDebugMode) {
      print('bottle');
    }
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where(
          "users",
          arrayContainsAny: [roomId, reverseRoomId],
        )
        .get()
        .then(
          (value) {
            if (kDebugMode) {
              print(value.docs.length);
            }

            if (value.docs.isEmpty) {
              if (kDebugMode) {
                print('======> NO, DIALOG NOT CREATED <======');
              }

              //
              funcCreateDialog();
              //
            } else {
              if (kDebugMode) {
                print('===> YES, THEY ALREADY CHATTED <===');
              }
              for (var element in value.docs) {
                if (kDebugMode) {
                  print(element.id);
                }
                //
                funcEditDialogWithTimeStamp(element.id);
                //
                return;
              }
              //
              //
              //
            }
          },
        );
  }

  //
  funcCreateDialog() {
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}dialog/India/details',
    );
    /*
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print('SENDER RECEIVER FID =====>${widget.strReceiverFirebaseId}');
      print('SENDER RECEIVER CHAT ID =====>${widget.strReceiverChatId}');
    }
    */
    users
        .add(
          {
            // sender
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_name': strLoginUserName.toString(),
            'sender_image': strLoginUserImage.toString(),
            // 'receiver_image': widget.chatDialogData['image'].toString(),

            // 'sender_chat_user_id': widget.strSenderChatId,
            //time stamp
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            //
            //receiver
            // 'receiver_name': widget.chatDialogData['fullName'].toString(),
            'receiver_firebase_id':
                widget.chatDialogData['firebaseId'].toString(),
            'deviceToken': widget.chatDialogData['deviceToken'].toString(),
            'chat_type': 'private',
            'message': lastMessage,
            'users': [
              roomId,
              reverseRoomId,
            ],
            'match': [
              FirebaseAuth.instance.currentUser!.uid,
              widget.chatDialogData['firebaseId'].toString()
            ]
          },
        )
        .then(
          (value) => print("==> DIALOG CREATED SUCCESSFULLY ==> ${value.id}"),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // UPDATE DIALOG AFTER SEND MESSAGE
  funcEditDialogWithTimeStamp(
    elementWithId,
  ) {
    if (kDebugMode) {
      print(widget.chatDialogData);
    }
    //
    if (kDebugMode) {
      print(widget.chatDialogData['fullName'].toString());
    }
    //
    var createName = '';
    if (widget.chatDialogData['fullName'].toString() == 'null') {
      if (FirebaseAuth.instance.currentUser!.uid ==
          widget.chatDialogData['sender_firebase_id'].toString()) {
        createName = widget.chatDialogData['receiver_name'].toString();
      } else {
        createName = widget.chatDialogData['sender_name'].toString();
      }
    } else {
      createName = widget.chatDialogData['fullName'].toString();
    }
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}dialog')
        .doc('India')
        .collection('details')
        .doc(elementWithId.toString())
        .set(
      {
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'message': lastMessage,
        // 'sender_name': strLoginUserName.toString(),
        'receiver_name': createName.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        // setState(() {
        // strSetLoader = '1';
        // });
        //
      },
    );
  }

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

// send message
  sendImageViaFirebase(imageURL) {
    setState(() {
      str_image_processing = '0';
    });

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/India/private_chats',
    );

    users
        .add(
          {
            'attachment_path': imageURL.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_name': strLoginUserName.toString(),

            'message': '',
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'private',
            'type': 'image',

            'sender_image': strLoginUserImage.toString(),

            // 'receiver_image': strReceiverImage.toString(),
            // 'receiver_name': strReceiverName.toString(),
            'receiver_firebase_id': strReceiverFirebaseId.toString(),

            // save room id
            'room_id': roomId.toString(),
            'users': [
              roomId,
              reverseRoomId,
            ]
          },
        )
        .then(
          (value) =>
              //
              funcCheckUsersIsAlreadyChatWithEachOther(),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // UPLOAD IMAGE ON FIREBASE
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
          sendImageViaFirebase(value)
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
