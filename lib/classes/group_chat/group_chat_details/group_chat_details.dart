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
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:uuid/uuid.dart';

import '../../controllers/database/database_helper.dart';
import '../../controllers/my_friends/my_friends_modal/my_friends_modal.dart';
import '../../header/utils.dart';
import '../group_friends_list/group_friends_list.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import '../controllers/database/database_helper.dart';
// import '../controllers/my_friends/my_friends_modal/my_friends_modal.dart';
// import '../header/utils.dart';

class GroupChatDetailsScreen extends StatefulWidget {
  const GroupChatDetailsScreen({super.key, this.dictGetDataForDetails});

  final dictGetDataForDetails;

  @override
  State<GroupChatDetailsScreen> createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  //
  var strFriendLoader = '1';
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
  //
  late final TextEditingController contEmail;
  //
  var strCheckmark = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  var strProfilImageLoader = '0';
  // var strGetUploadImageURL = '';
  //
  // var arrGroupDetails = [];
  var strGetImageData = '';
  //
  var strSaveGroupNameAfterUpdate = '';
  // var strSaveGroupImageAfterUpdate = '';
  //
  var arrMembers = [];
  var arrMembersDetails = [];
  //
  var strDeleteGroupButton = '0';
  //
  var arrSaveXMPPmembers = [];
  //
  @override
  void initState() {
    //

    //
    handler = DataBase();
    // funcGetLocalDBdata();
    //

    //
    if (kDebugMode) {
      print('================ GROUP DATA =====================');
      print(widget.dictGetDataForDetails);
      print(widget.dictGetDataForDetails['members_details']);
      print(widget.dictGetDataForDetails['members_details'].length);
      print(widget.dictGetDataForDetails['members_details'].length.runtimeType);
      print('=================================================');
    }
    super.initState();
    //
    funcGroupDetails();
    //
  }

  funcGroupDetails() {
    // set group name
    contEmail = TextEditingController(
        text: widget.dictGetDataForDetails['group_name'].toString());
    strSaveGroupNameAfterUpdate =
        widget.dictGetDataForDetails['group_name'].toString();
    // set image

    strGetImageData =
        widget.dictGetDataForDetails['group_display_image'].toString();
    //
    // funcGetLocalDBdata();
    //
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
                    //
                    strLoginUserId = value[i].userId.toString(),
                    // print('dishant rajput 1.1 ====> $strLoginUserId'),
                    // print(widget.strUserId),
                    //
                  },
                //
                // HIT WEBSERVICE TO SEARCH FRIEND
                friendApiCall
                    .friendsWB(
                      strLoginUserId.toString(),
                      '1',
                    )
                    .then((value) => {
                          setState(() {
                            arrSearchFriend = value;
                            strFriendLoader = '1';
                          })
                        }),
                //
                //
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
          'Details',
          Colors.white,
          18.0,
        ),
        //
        leading: (strGetImageData == '')
            ? IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    strSaveGroupNameAfterUpdate.toString(),
                  );
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
        backgroundColor: navigationColor,
        // actions: [
        //   (strDeleteGroupButton == '1')
        //       ? IconButton(
        //           onPressed: () {
        //             print('delete group');
        //           },
        //           icon: const Icon(
        //             Icons.delete_forever,
        //             color: Colors.white,
        //           ),
        //         )
        //       : const SizedBox(
        //           height: 0,
        //         )
        // ],
      ),
      body: (strFriendLoader == '0')
          ? Center(
              child: CircularProgressIndicator(
                color: navigationColor,
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('${strFirebaseMode}dialog')
                  .doc('India')
                  .collection('details')
                  .orderBy('time_stamp', descending: true)
                  .where('group_id',
                      isEqualTo:
                          widget.dictGetDataForDetails['group_id'].toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (kDebugMode) {
                    print(snapshot.data!.docs[0]['match'][0]);
                  }

                  var saveSnapshotValue = snapshot.data!.docs;
                  if (kDebugMode) {
                    print('============== DIALOGS ==============');
                    print(saveSnapshotValue[0]['match']);
                    print('======================================');
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(snapshot.data!.docs[0]['members_details'][3]
                        // ['firebase_id']);
                        //
                        arrMembers = snapshot.data!.docs[0]['match'];
                        //

                        arrMembersDetails =
                            snapshot.data!.docs[0]['members_details'];
                        //
                        if (kDebugMode) {
                          print('============== MATCH ==============');
                          print(arrMembersDetails);
                          print('======================================');
                        }
                        (snapshot.data!.docs[0]['members_details'][0]
                                    ['firebase_id'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? strDeleteGroupButton = '1'
                            : strDeleteGroupButton = '0';

                        //
                        funcGetFriendsList(arrMembersDetails);
                        //
                        return Column(
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
                                ' Members',
                                Colors.black,
                                22.0,
                              ),
                            ),
                            //

                            //
                            for (int i = 0;
                                i <
                                    snapshot.data!.docs[0]['members_details']
                                        .length;
                                i++) ...[
                              ListTile(
                                leading: (snapshot.data!.docs[0]
                                                ['members_details'][i]
                                            ['profile_picture'] ==
                                        '')
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Image.asset(
                                            //
                                            'assets/icons/avatar.png',
                                            //
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Image.network(
                                            //
                                            snapshot.data!.docs[0]
                                                    ['members_details'][i]
                                                ['profile_picture'],
                                            //
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                title: textWithBoldStyle(
                                  //
                                  snapshot.data!.docs[0]['members_details'][i]
                                      ['name'],
                                  //
                                  Colors.black,
                                  14.0,
                                ),
                                trailing: (snapshot.data!.docs[0]
                                            ['members_details'][i]['type'] ==
                                        'Admin')
                                    ? textWithBoldStyle(
                                        //
                                        snapshot.data!.docs[0]
                                            ['members_details'][i]['type'],
                                        //
                                        Colors.black,
                                        14.0,
                                      )
                                    : (snapshot.data!.docs[0]['members_details']
                                                [0]['firebase_id'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? InkWell(
                                            onTap: () {
                                              print(
                                                  'admin click remove button');
                                              //
                                              funcGetMemberDetailsxmpp(
                                                  i,
                                                  snapshot
                                                      .data!
                                                      .docs[0]
                                                          ['members_details'][i]
                                                          ['firebase_id']
                                                      .toString());
                                              //
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  14.0,
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
                                              child: Center(
                                                child: textWithRegularStyle(
                                                  'Remove',
                                                  Colors.white,
                                                  14.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                              ),
                              //
                              Container(
                                height: 0.4,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black,
                              ),
                            ],
                            //
                            const SizedBox(
                              height: 40,
                            ),
                            (snapshot.data!.docs[0]['members_details'][0]
                                        ['firebase_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? GestureDetector(
                                    onTap: () {
                                      QuickAlert.show(
                                        context: context,
                                        barrierColor: Colors.blueGrey,
                                        type: QuickAlertType.confirm,
                                        text:
                                            'Are you sure you want ot delete this group ?',
                                        confirmBtnText: 'Yes',
                                        cancelBtnText: 'No',
                                        confirmBtnColor: Colors.green,
                                        onConfirmBtnTap: () {
                                          if (kDebugMode) {
                                            print('some click');
                                          }
                                          Navigator.pop(context);

                                          // delete old local DB
                                          funcDeleteWholeGroup();
                                          //

                                          //
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                //
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GroupFriendsListScreen(
                                                      dictDetails: snapshot
                                                              .data!.docs[0]
                                                          ['members_details'],
                                                    ),
                                                  ),
                                                );
                                                //
                                              },
                                              child: textWithBoldStyle(
                                                'Add Participants',
                                                Colors.black,
                                                14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        //
                                        /* ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          // scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: arrSearchFriend.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              leading: (strLoginUserId ==
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString())
                                                  ? (arrSearchFriend[index][
                                                                  'FirstUserimage']
                                                              .toString() ==
                                                          '')
                                                      ? Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.amber,
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
                                                            color: Colors.amber,
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
                                                            child:
                                                                Image.network(
                                                              //
                                                              arrSearchFriend[
                                                                          index]
                                                                      [
                                                                      'FirstUserimage']
                                                                  .toString(),
                                                              height: 60,
                                                              width: 60,
                                                              fit: BoxFit.cover,
                                                              //
                                                            ),
                                                          ),
                                                        )
                                                  : (arrSearchFriend[index][
                                                                  'SecondUserimage']
                                                              .toString() ==
                                                          '')
                                                      ? Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.amber,
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
                                                            color: Colors.amber,
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
                                                            child:
                                                                Image.network(
                                                              //
                                                              arrSearchFriend[
                                                                          index]
                                                                      [
                                                                      'SecondUserimage']
                                                                  .toString(),
                                                              height: 60,
                                                              width: 60,
                                                              fit: BoxFit.cover,
                                                              //
                                                            ),
                                                          ),
                                                        ),
                                              title: (strLoginUserId ==
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString())
                                                  ? textWithBoldStyle(
                                                      //
                                                      arrSearchFriend[index]
                                                              ['FirstfullName']
                                                          .toString(),
                                                      // '12',
                                                      //
                                                      Colors.black,
                                                      16.0,
                                                    )
                                                  : textWithBoldStyle(
                                                      //
                                                      arrSearchFriend[index]
                                                              ['SecondfullName']
                                                          .toString(),
                                                      // '12',
                                                      //
                                                      Colors.black,
                                                      16.0,
                                                    ),
                                              subtitle: (strLoginUserId ==
                                                      arrSearchFriend[index]
                                                              ['userId']
                                                          .toString())
                                                  ? textWithRegularStyle(
                                                      //
                                                      arrSearchFriend[index]
                                                              ['Firstemail']
                                                          .toString(),
                                                      // '12',
                                                      Colors.blueGrey,
                                                      14.0,
                                                    )
                                                  : textWithRegularStyle(
                                                      //
                                                      arrSearchFriend[index]
                                                              ['Secondemail']
                                                          .toString(),
                                                      // '12',
                                                      Colors.blueGrey,
                                                      14.0,
                                                    ),
                                              trailing: InkWell(
                                                onTap: () {
                                                  //
                                                  
                                                },
                                                child: (arrSearchFriend[index]
                                                                ['status']
                                                            .toString() ==
                                                        '2')
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .all(10.0),
                                                        width: 100,
                                                        height: 48.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              navigationColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            20,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child:
                                                              textWithBoldStyle(
                                                            'Add',
                                                            Colors.white,
                                                            16.0,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                      ),
                                              ),
                                            );
                                          },
                                        ),*/
                                        /*for (int i = 0;
                                            i < arrSearchFriend.length;
                                            i++) ...[
                                          ListTile(
                                            leading: (snapshot.data!.docs[0]
                                                            ['members_details'][
                                                        i]['profile_picture'] ==
                                                    '')
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                        //
                                                        'assets/icons/avatar.png',
                                                        //
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.network(
                                                        //
                                                        snapshot.data!.docs[0][
                                                                'members_details']
                                                            [
                                                            i]['profile_picture'],
                                                        //
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                            title: textWithBoldStyle(
                                              //
                                              snapshot.data!.docs[0]
                                                      ['members_details'][i]
                                                  ['name'],
                                              //
                                              Colors.black,
                                              14.0,
                                            ),
                                            trailing: (snapshot.data!.docs[0]
                                                            ['members_details']
                                                        [i]['type'] ==
                                                    'Admin')
                                                ? textWithBoldStyle(
                                                    //
                                                    snapshot.data!.docs[0]
                                                            ['members_details']
                                                        [i]['type'],
                                                    //
                                                    Colors.black,
                                                    14.0,
                                                  )
                                                : (snapshot.data!.docs[0][
                                                                'members_details']
                                                            [
                                                            0]['firebase_id'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)
                                                    ? InkWell(
                                                        onTap: () {
                                                          print(
                                                              'admin click remove button');
                                                          //
                                                          funcGetMemberDetailsxmpp(
                                                              i,
                                                              snapshot
                                                                  .data!
                                                                  .docs[0][
                                                                      'members_details']
                                                                      [i][
                                                                      'firebase_id']
                                                                  .toString());
                                                          //
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              14.0,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xffDDDDDD),
                                                                blurRadius: 6.0,
                                                                spreadRadius:
                                                                    2.0,
                                                                offset: Offset(
                                                                    0.0, 0.0),
                                                              )
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child:
                                                                textWithRegularStyle(
                                                              'Remove',
                                                              Colors.white,
                                                              14.0,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                      ),
                                          ),
                                        ],*/
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        textWithRegularStyle(
                                          'Delete Group',
                                          Colors.red,
                                          14.0,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  )
                          ],
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
      /*Column(
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
                      ' Members',
                      Colors.black,
                      22.0,
                    ),
                  ),
                  //
                  for (int i = 0; i < arrGroupDetails.length; i++) ...[
                    ListTile(
                      leading: (arrGroupDetails[i]['member_photo'] == '')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset(
                                  //
                                  'assets/icons/avatar.png',
                                  //
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.network(
                                  //
                                  arrGroupDetails[i]['member_photo'],
                                  //
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      title: textWithBoldStyle(
                        //
                        arrGroupDetails[i]['member_name'],
                        //
                        Colors.black,
                        14.0,
                      ),
                      trailing: (arrGroupDetails[i]['type'] == 'Admin')
                          ? textWithBoldStyle(
                              //
                              arrGroupDetails[i]['type'],
                              //
                              Colors.black,
                              14.0,
                            )
                          : (arrGroupDetails[0]['member_firebase_id']
                                      .toString() ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? InkWell(
                                  onTap: () {
                                    print('admin click remove button');
                                    //
                                    funcGetMemberDetailsxmpp(
                                        i,
                                        arrGroupDetails[i]['member_firebase_id']
                                            .toString());
                                    //
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(
                                        14.0,
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
                                    child: Center(
                                      child: textWithRegularStyle(
                                        'Remove',
                                        Colors.white,
                                        14.0,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                )
                      /*(arrGroupDetails[i]['type'].toString() == 'Admin')
                              ? InkWell(
                                  onTap: () {
                                    print('admin click remove button');
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(
                                        14.0,
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
                                    child: Center(
                                      child: textWithRegularStyle(
                                        'Remove',
                                        Colors.white,
                                        14.0,
                                      ),
                                    ),
                                  ),
                                )
                              : textWithRegularStyle(
                                  'str',
                                  Colors.amber,
                                  14.0,
                                )*/
                      ,
                    ),
                    //
                    Container(
                      height: 0.4,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                    ),
                  ]

                  //
                ],
              ),*/
    );
  }

  //
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
                ? (strGetImageData == '')
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
                            40,
                          ),
                          child: Image.network(
                            strGetImageData,
                            fit: BoxFit.cover,
                          ),
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
                          child: const CircularProgressIndicator(),
                        ),
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
                  onEditingComplete: () {
                    //do your stuff
                    if (kDebugMode) {
                      print('dismiss keybaord');
                    }

                    // dismiss keyboard
                    FocusScope.of(context).requestFocus(FocusNode());
                    //

                    funcGetDataXMPP();
                    //
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
                  //
                  /*const snackBar = SnackBar(
                    backgroundColor: Colors.blueAccent,
                    content: Text('updating....'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //
                  */
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
  funcGetDataXMPP() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

    //
    const snackBar = SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Text('updating....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
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
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            print(element.id.runtimeType);
          }
          //
          funcUpdateNameXMPP(
            element.id,
          );
          //
        }
      }
    });
    //
  }

  //
  funcUpdateNameXMPP(firestoreId) {
    if (kDebugMode) {
      print('=============== FIRESTORE ID ======================');
      print(firestoreId);
      print('====================================================');
    }
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc('India')
        .collection('details')
        .doc(firestoreId)
        .set(
      {
        'group_name': contEmail.text.toString(),
        'group_display_image': strGetImageData.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //
        const snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text('Updated....'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        setState(() {
          strSaveGroupNameAfterUpdate = contEmail.text.toString();

          strProfilImageLoader = '2';
        });

        //
      },
    );
    //
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
            //
            strGetImageData = value;
            //
            funcGetDataXMPP();
          })

          //

          //
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
  //
  //
  /*funcGetDataFromXMPP() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
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
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            print(element.id.runtimeType);
          }
          //
          funcUpdateImageXMPP(
            element.id,
          );
          //
        }
      }
    });
    //
  }

  //
  funcUpdateImageXMPP(firestoreId) {
    if (kDebugMode) {
      print('=============== FIRESTORE ID ======================');
      print(firestoreId);
      print('====================================================');
    }
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc('India')
        .collection('details')
        .doc(firestoreId)
        .set(
      {
        'group_display_image': strSaveGroupImageAfterUpdate.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        setState(() {
          strProfilImageLoader = '2';
        });

        //
      },
    );
    //
  }*/
  //
  funcGetMemberDetailsxmpp(
    getCellId,
    getUserFirebaseId,
  ) {
//

    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());

      print('=============== CLICKED USER FIREBASE ID ======================');
      print(getUserFirebaseId.toString());
      print('====================================================');
    }

//
    const snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('deleting....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs.length);
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
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print('=============== GROUP FIRESTORE ID ======================');
            print(element.id);
            print('====================================================');

            print(element.id.runtimeType);
          }
          //
          funcDeleteFirebaseIdFromMATCHxmpp(
            element.id,
            getUserFirebaseId.toString(),
          );
          //
        }
      }
    });
    //
  }

  //
  funcDeleteFirebaseIdFromMATCHxmpp(
    firestoreId,
    deleteUserFirebaseId,
  ) {
    print(widget.dictGetDataForDetails['match']);
    //
    var arrRemoveFriendFromMembers = [];
    //
    for (int i = 0; i < arrMembers.length; i++) {
      if (arrMembers[i].toString() == deleteUserFirebaseId.toString()) {
        print('yes match');
      } else {
        print('no match');
        arrRemoveFriendFromMembers.add(arrMembers[i]);
      }
    }
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .doc(firestoreId)
        .update({
      'match': arrRemoveFriendFromMembers,
    }).then((value) => {
              //
              //
              arrRemoveFriendFromMembers.clear(),
              //
              funcDeleteMemberFullDetailsFromThisGroup(
                firestoreId,
                deleteUserFirebaseId,
              ),
              //
            });
  }

  // also delete member full details
  funcDeleteMemberFullDetailsFromThisGroup(
    firestoreId,
    deleteUserFirebaseId,
  ) {
    // print('member details call');
    /*print('=============== MEMBERS IN GROUP ======================');
    print(arrMembersDetails);
    print(arrMembersDetails.length);*/

    //
    var arrRemoveFriendFromMembers = [];
    // //
    for (int i = 0; i < arrMembersDetails.length; i++) {
      //
      if (arrMembersDetails[i]['firebase_id'].toString() ==
          deleteUserFirebaseId.toString()) {
        print('yes match');
      } else {
        var custom = {
          'active': arrMembersDetails[i]['active'].toString(),
          'evs_id': arrMembersDetails[i]['evs_id'].toString(),
          'firebase_id': arrMembersDetails[i]['firebase_id'].toString(),
          'name': arrMembersDetails[i]['name'].toString(),
          'profile_picture': arrMembersDetails[i]['profile_picture'].toString(),
          'type': arrMembersDetails[i]['type'].toString(),
        };
        //
        arrRemoveFriendFromMembers.add(custom);
      }
      //
    }
    //
    /*print(arrRemoveFriendFromMembers);
    print(arrRemoveFriendFromMembers.length);*/
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .doc(firestoreId)
        .update({
      'members_details': arrRemoveFriendFromMembers,
    }).then((value) => {
              //
              arrRemoveFriendFromMembers.clear(),
              //
            });
    //
    //
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('removed....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //
  }

  //
  funcDeleteWholeGroup() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

//
    const snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('deleting....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs.length);
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
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print('=============== GROUP FIRESTORE ID ======================');
            print(element.id);
            print('=========================================================');

            print(element.id.runtimeType);
          }
          //
          FirebaseFirestore.instance
              .collection("${strFirebaseMode}dialog")
              .doc("India")
              .collection("details")
              .doc(element.id)
              .delete()
              .then((value) => {
                    Navigator.pop(context),
                    Navigator.pop(context),
                  });
          //
        }
      }
    });
  }

  //
  funcGetFriendsList(getMembersDetails) {
    print('==========================================================');
    print('=================== XMPP MEMBERS =========================');
    print(getMembersDetails);
    print('==========================================================');
    print('=============== LOCAL SERVER MEMBERS =====================');
    print(arrSearchFriend);
    print('==========================================================');
    print('==========================================================');
  }
}
