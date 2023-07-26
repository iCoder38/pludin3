// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/database/database_helper.dart';
import '../../controllers/my_friends/my_friends_modal/my_friends_modal.dart';
import '../../header/utils.dart';

class GroupFriendsListScreen extends StatefulWidget {
  const GroupFriendsListScreen({super.key, this.dictDetails});

  final dictDetails;

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
  @override
  void initState() {
    //
    handler = DataBase();

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
                      '1',
                    )
                    .then((value) => {
                          setState(() {
                            arrSearchFriend = value;
                            strFriendLoader = '1';
                            //
                            funcManageXMPPAndLocalFriends();
                            //
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

  //
  funcManageXMPPAndLocalFriends() {
    print('=================== XMPP MEMBERS =========================');
    print(widget.dictDetails);
    print('==========================================================');
    print('=================== LOCAL MEMBERS =========================');
    print(arrSearchFriend);
    print('==========================================================');
    //
    /*
    
        */
    var arrDummy = [];
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
    print('=================== DUMMY =========================');
    print(arrDummy);
    print(arrDummy.length);
    print('===================================================');
    //
    var arrA = [];
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
    for (int i = 0; i < result.length; i++) {}
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
    );
  }
}
