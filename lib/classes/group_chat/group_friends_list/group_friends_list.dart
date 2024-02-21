// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/database/database_helper.dart';
import '../../controllers/my_friends/my_friends_modal/my_friends_modal.dart';
import '../../header/utils.dart';

class GroupFriendsListScreen extends StatefulWidget {
  const GroupFriendsListScreen(
      {super.key, this.dictDetails, required this.groupId});

  final dictDetails;
  final String groupId;

  @override
  State<GroupFriendsListScreen> createState() => _GroupFriendsListScreenState();
}

class _GroupFriendsListScreenState extends State<GroupFriendsListScreen> {
  //
  late DataBase handler;
  var arrSearchFriend = [];
  final friendApiCall = FriendModal();
  var strLoginUserId = '';
  var strLoginFirebaseId = '';
  var strFriendLoader = '1';
  //
  var createArray = [];
  var arrDummy = [];
  //
  var str_screeen_alert = '0';
  //
  @override
  void initState() {
    //
    handler = DataBase();

    print('=================================');
    print('============ GROUP ID ===========');
    print(widget.groupId);
    print('=================================');
    //
    funcGetLocalDBdata();
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
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    strLoginFirebaseId = value[i].firebaseId.toString(),

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
                          // setState(() {
                          arrSearchFriend = value,
                          strFriendLoader = '1',
                          //
                          // funcManageXMPPAndLocalFriends();
                          funcCheckIsThisFriendIsAvailaibleOrNot(),
                          //
                          //})
                        }),
                //
                //
              });
        }
      },
    );
    //
  }

  funcCheckIsThisFriendIsAvailaibleOrNot() {
    // print('=================== XMPP MEMBERS =========================');
    // print(widget.dictDetails);
    // print(widget.dictDetails.length);
    // print('==============');
    // print('==============');

    // print(arrSearchFriend);

    /*for (int j = 0; j < widget.dictDetails.length; j++) {
      print('j =====> ' '$j');
      for (int i = 0; i < arrSearchFriend.length; i++) {
        // remove my data from xmpp
        print('i =====> ' '$i');
      }
    }*/
    //
    // createArray = widget.dictDetails;
    // print(createArray);

    funcManageXMPPAndLocalFriends();
  }

  //
  funcManageXMPPAndLocalFriends() {
    print('=================== XMPP MEMBERS =========================');
    print(widget.dictDetails);
    print('==========================================================');
    // print('=================== LOCAL MEMBERS =========================');
    // print(arrSearchFriend);
    // print('==========================================================');
    //
    /*
    
        */

    for (int z = 0; z < arrSearchFriend.length; z++) {
      var custom = {
        'evs_id': (strLoginUserId == arrSearchFriend[z]['userId'].toString())
            ? arrSearchFriend[z]['profileId'].toString()
            : arrSearchFriend[z]['userId'].toString(),
        'name': (strLoginUserId == arrSearchFriend[z]['userId'].toString())
            ? arrSearchFriend[z]['FirstfullName'].toString()
            : arrSearchFriend[z]['SecondfullName'].toString(),
        'firebase_id': (strLoginFirebaseId ==
                arrSearchFriend[z]['FirstFirebaseId'].toString())
            ? arrSearchFriend[z]['SecondFirebaseId'].toString()
            : arrSearchFriend[z]['FirstFirebaseId'].toString(),
        'profile_picture':
            (strLoginUserId == arrSearchFriend[z]['userId'].toString())
                ? arrSearchFriend[z]['FirstUserimage'].toString()
                : arrSearchFriend[z]['SecondUserimage'].toString(),
        'type': 'member',
        'active': 'yes'
      };
      arrDummy.add(custom);
    }
    //
    // print('=================== DUMMY =========================');
    // print(arrDummy);
    // print(arrDummy.length);
    // print('===================================================');
    //
    for (int i = 0; i < widget.dictDetails.length; i++) {
      if (i == 0) {
      } else {
        print('work done');
        print(widget.dictDetails[i]);
        //
        //
        for (int j = 0; j < arrDummy.length; j++) {
          print(j);
          if (widget.dictDetails[i]['evs_id'].toString() ==
              arrDummy[j]['evs_id'].toString()) {
            print('remove');
            //
            arrDummy.removeAt(j);
          } else {
            // print('do not remove');
          }
        }
        //
        print('=================== DUMMY =========================');
        print(arrDummy);
        print(arrDummy.length);
        if (arrDummy.isEmpty) {
          str_screeen_alert = '2';
        }
      }
    }
    setState(() {});
    //
    /*var arrA = [];
    var arrB = [];
    print('xmpp friends');
    //
    for (int i = 0; i < widget.dictDetails.length; i++) {
      for (int j = 0; j < arrDummy.length; j++) {
        //
        if (widget.dictDetails[i]['evs_id'].toString() ==
            arrDummy[i]['evs_id'].toString()) {
          print('object');
          return;
        } else {
          print('object 2');
          // return;
        }
        // print(widget.dictDetails[i]['evs_id'].toString());
      }
    }
    print('local friends');

    //
    for (int i = 0; i < widget.dictDetails.length; i++) {
      print(widget.dictDetails[i]['evs_id']);
      // arrA = widget.dictDetails[i]['evs_id']
      arrA.add(widget.dictDetails[i]['evs_id']);
    }
    print('local friends');
    for (int j = 0; j < arrDummy.length; j++) {
      // print(arrDummy[j]['evs_id'].toString());
      arrB.add(arrDummy[j]['evs_id']);
    }
    //
    // .toSet().toList();
    print(arrA + arrB);
    var ids2 = arrA + arrB;
    //
    var result = ids2.toSet().toList();
    print(result);
    //
    for (int i = 0; i < result.length; i++) {}*/
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Friends',
          Colors.white,
          18.0,
        ),
        //
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        backgroundColor: navigationColor,
      ),
      body: (str_screeen_alert == '2')
          ? Center(
              child: textWithRegularStyle(
                'All of your friends are added in this group.',
                Colors.black,
                14.0,
              ),
            )
          : Column(
              children: [
                //

                for (int i = 0; i < arrDummy.length; i++) ...[
                  //
                  //
                  ListTile(
                    title: textWithRegularStyle(
                      arrDummy[i]['name'].toString(),
                      Colors.black,
                      14.0,
                    ),
                    //
                    trailing: IconButton(
                      onPressed: () {
                        //
                        funcAddOneParticipant(i);
                        //
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  //
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[350],
                  )
                  //
                ],
              ],
            ),
    );
  }

  //
  //
  funcAddOneParticipant(indexx) {
    //
    var arrCustomDataAdd = [];
    var custom = {
      'evs_id': arrDummy[indexx]['evs_id'].toString(),
      'name': arrDummy[indexx]['name'].toString(),
      'firebase_id': arrDummy[indexx]['firebase_id'].toString(),
      'profile_picture': arrDummy[indexx]['profile_picture'].toString(),
      'type': 'member',
      'active': 'yes'
    };
    //
    arrCustomDataAdd.add(custom);

    print('=================================================');
    print('================= custom ====================');
    print(arrCustomDataAdd);
    // print(arrDummy.removeAt(indexx));
    print('=================================================');
    print('============== dummy ===================');
    print(arrDummy[indexx]);
    print(arrDummy.length);
    print('=================================================');
    print('============== dummy index number after remove ===================');
    arrDummy.removeAt(indexx);
    print(arrDummy.length);
    setState(() {
      //
      // print(arrCustomDataAdd);
      funcFind(arrCustomDataAdd);
      //
    });
    /*print('=================================================');
    print('============== index ===================');
    print(indexx);
    setState(() {});
    //
    funcFind(arrCustomDataAdd[indexx]);*/
    //
  }

  //
  funcFind(data1) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where("group_id", isEqualTo: widget.groupId.toString())
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
        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            // print(element.data()['']);
            // print(element.id.runtimeType);
          }
          //
          funcUpdate(
            element.id,
            data1,
          );
        }
      }
    });

    //
  }

  //
  //
  funcUpdate(elementId, data2) {
    print('==========================');
    print('UPDATE MEMBER DETAILS');
    print(elementId);
    print(data2);

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc('India')
        .collection('details')
        .doc(elementId)
        .set(
      {
        'members_details': FieldValue.arrayUnion(
          data2,
        ),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        funcUpdateMatch(elementId, data2); //
      },
    );
  }

  //
  // also update match
  funcUpdateMatch(elementId3, data3) {
    print('==========================');
    print('UPDATE MATCH');
    print(elementId3);
    print(data3);
    print(data3[0]);
    print(data3[0]['firebase_id'].toString());
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc('India')
        .collection('details')
        .doc(elementId3)
        .set(
      {
        'match': FieldValue.arrayUnion(
          [data3[0]['firebase_id']],
        ),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        // Navigator.pop(context);
        //
      },
    );
  }
}
