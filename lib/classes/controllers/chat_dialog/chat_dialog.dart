// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/chat/chat.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/group_chat/group_chat.dart';
import 'package:pludin/classes/header/utils.dart';

// import '../../custom/app_bar.dart';
// import 'package:my_new_orange/classes/private_chat/private_chat_room.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';

// import 'package:my_new_orange/header/utils/custom/app_bar.dart';
// import 'package:badges/badges.dart';

class DialogScreen extends StatefulWidget {
  const DialogScreen({
    super.key,
    // required this.str_dialog_login_user_chat_id,
    //required this.str_dialog_login_user_gender
  });

  // final String str_dialog_login_user_chat_id;
  // final String str_dialog_login_user_gender;

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  //
  FirebaseAuth firebase_auth = FirebaseAuth.instance;
  //
  // var str_user_id;
  @override
  void initState() {
    super.initState();
    // str_user_id =
    //  '${firebase_auth.currentUser!.uid}+${widget.str_dialog_login_user_chat_id}';

    // final splitted = str_user_id.split('+');
    // if (kDebugMode) {
    //   print(widget.str_dialog_login_user_chat_id);
    //   print(splitted[0]);
    //   print(splitted[1]);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Chats',
          Colors.white,
          18.0,
        ),
        backgroundColor: navigationColor,
        actions: [
          const Icon(
            Icons.add,
            size: 0.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'push_to_create_group_screen');
            },
            child: SizedBox(
              height: 40,
              width: 100,
              // color: Colors.amber,
              child: Center(
                child: textWithRegularStyle(
                  'Create group',
                  Colors.white,
                  14.0,
                ),
              ),
            ),
          ),
          //
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: StreamBuilder(
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
              print(snapshot.data!.docs.length);
            }

            var save_snapshot_value = snapshot.data!.docs;
            if (kDebugMode) {
              print(save_snapshot_value);
            }
            return Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      //

                      //
                      if (kDebugMode) {
                        print('=====> dishant rajput <=====');
                        print(
                            snapshot.data!.docs[index]['chat_type'].toString());
                      }
                      //
                      if (snapshot.data!.docs[index]['chat_type'].toString() ==
                          'group') {
                        //
                        func_push_to_group_chat(
                            snapshot.data!.docs[index].data());
                        //
                      } else {
                        func_push_to_private_chat(
                            snapshot.data!.docs[index].data());
                      }
                    },
                    child:
                        (snapshot.data!.docs[index]['chat_type'].toString() ==
                                'group')
                            ? groupChatUI(snapshot, index)
                            : privateChatUI(snapshot, index),
                  );
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
    );
  }

  ListTile groupChatUI(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return ListTile(
      leading: (snapshot.data!.docs[index]['group_display_image'].toString() ==
              '')
          ? Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/icons/group.png',
                  ),
                ),
              ),
            )
          : SizedBox(
              height: 54,
              width: 54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  27.0,
                ),
                child: Image.network(
                  snapshot.data!.docs[index]['group_display_image'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      title: textWithBoldStyle(
        //
        snapshot.data!.docs[index]['group_name'].toString(),
        //
        Colors.black,
        18.0,
      ),
      subtitle: (snapshot.data!.docs[index]['message'].toString() == '')
          ? Row(
              children: [
                const Icon(
                  Icons.image,
                  size: 20.0,
                ),
                textWithRegularStyle(
                  ' Image',
                  Colors.black,
                  14.0,
                ),
              ],
            )
          : ((snapshot.data!.docs[index]['message'].toString()).length > 40)
              ? Text(
                  (snapshot.data!.docs[index]['message'].toString())
                      .replaceRange(
                          40,
                          (snapshot.data!.docs[index]['message'].toString())
                              .length,
                          '...'),
                  style: const TextStyle(
                    // fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                )
              : textWithRegularStyle(
                  (snapshot.data!.docs[index]['message'].toString()),
                  Colors.black,
                  14.0,
                ),
    );
  }

  ListTile privateChatUI(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return ListTile(
      leading: (snapshot.data!.docs[index]['sender_firebase_id'].toString() ==
              FirebaseAuth.instance.currentUser!.uid)
          ? Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: (snapshot.data!.docs[index]['receiver_image'].toString() ==
                      '')
                  ? Container(
                      height: 54,
                      width: 54,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        27.0,
                      ),
                      child: Image.network(
                        snapshot.data!.docs[index]['receiver_image'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
            )
          : Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: (snapshot.data!.docs[index]['sender_image'].toString() ==
                      '')
                  ? Container(
                      height: 54,
                      width: 54,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        27.0,
                      ),
                      child: Image.network(
                        snapshot.data!.docs[index]['sender_image'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      title: (snapshot.data!.docs[index]['sender_firebase_id'].toString() ==
              FirebaseAuth.instance.currentUser!.uid)
          ? textWithBoldStyle(
              //
              snapshot.data!.docs[index]['receiver_name'].toString(),
              //
              Colors.black,
              18.0,
            )
          : textWithRegularStyle(
              //
              snapshot.data!.docs[index]['sender_name'].toString(),
              //
              Colors.black,
              14.0,
            ),
      subtitle: (snapshot.data!.docs[index]['message'].toString() == '')
          ? Row(
              children: [
                const Icon(
                  Icons.image,
                  size: 20.0,
                ),
                textWithRegularStyle(
                  ' Image',
                  Colors.black,
                  14.0,
                ),
              ],
            )
          : ((snapshot.data!.docs[index]['message'].toString()).length > 40)
              ? Text(
                  (snapshot.data!.docs[index]['message'].toString())
                      .replaceRange(
                          40,
                          (snapshot.data!.docs[index]['message'].toString())
                              .length,
                          '...'),
                  style: const TextStyle(
                    // fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                )
              : textWithRegularStyle(
                  (snapshot.data!.docs[index]['message'].toString()),
                  Colors.black,
                  14.0,
                ),
    );
  }

  // push
  func_push_to_private_chat(dict_dialog_data) {
    if (kDebugMode) {
      print(dict_dialog_data);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatDialogData: dict_dialog_data,
          strFromDialog: 'yes',
        ),
      ),
    );
  }

  //
  func_push_to_group_chat(dict_dialog_data) {
    if (kDebugMode) {
      print(dict_dialog_data);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(
          chatDialogData: dict_dialog_data,
        ),
      ),
    );
  }
}
