// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/notification/notification_details.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controllers/database/database_helper.dart';
import '../controllers/drawer/drawer.dart';
import '../header/utils.dart';

import 'package:loadmore/loadmore.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  //
  late DataBase handler;
  var strGetUserId = '';
  var arrNotificationList = [];
  var strLoaderAndMessage = '0';
  var strRefreshLoader = '0';
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  var pageNumber = 1;
  //
  @override
  void initState() {
    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
    _needsScroll = true;
    super.initState();
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
        //
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
                    strGetUserId = value[i].userId.toString(),
                    //
                  },
                //

                //
                notificationListWB(1),
                //
              });
        }
      },
    );
    //
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // onNotification: (scrollEnd) {
      //   final metrics = scrollEnd.metrics;
      //   if (metrics.atEdge) {
      //     bool isTop = metrics.pixels == 0;
      //     if (isTop) {
      //       if (kDebugMode) {
      //         print('At the top');
      //       }
      //     } else {
      //       if (kDebugMode) {
      //         print('At the bottom');
      //       }
      //     }
      //   }
      //   return true;
      // },
      appBar: AppBar(
        title: textWithRegularStyle(
          'Notifications',
          Colors.white,
          18.0,
        ),
        backgroundColor: navigationColor,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              bool isTop = metrics.pixels == 0;
              if (isTop) {
                if (kDebugMode) {
                  print('At the top 2');
                }
                //
              } else {
                if (kDebugMode) {
                  print('At the bottom');
                }
                //
                // showLoadingUI(context, 'please wait...');
                pageNumber += 1;
                if (kDebugMode) {
                  print(pageNumber);
                }
                // notificationListWB(pageNumber);
                //
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (int i = 0; i < arrNotificationList.length; i++) ...[
                  // ListTile(
                  //   title: textWithRegularStyle(
                  //     'str',
                  //     Colors.black,
                  //     16.0,
                  //   ),
                  // ),
                  Column(
                    children: [
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      // for (int i = 0;
                      // i < arrNotificationList.length;
                      // i++) ...[
                      (arrNotificationList[i]['messagejson']['type']
                                  .toString() ==
                              'friend_send')
                          ? friendRequestUI(context, i)
                          : (arrNotificationList[i]['messagejson']['type']
                                      .toString() ==
                                  'friend_accept')
                              ? acceptedYourFriendReequestUI(i)
                              : GestureDetector(
                                  //
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationDetailsScreen(
                                          dictGetPostId: arrNotificationList[i],
                                          strPostType: arrNotificationList[i]
                                                  ['messagejson']['type']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                    //
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Dismissible(
                                      direction: DismissDirection.endToStart,
                                      resizeDuration:
                                          const Duration(microseconds: 100),
                                      key: ObjectKey(
                                        arrNotificationList[i],
                                      ),
                                      onDismissed: (direction) {
                                        //
                                        funcDeleteAfterAccept(
                                          arrNotificationList[i]
                                                  ['notificationid']
                                              .toString(),
                                        );
                                        //
                                      },
                                      background: Container(
                                        padding: const EdgeInsets.only(
                                          left: 28.0,
                                        ),
                                        color: Colors.redAccent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            ),
                                            textWithRegularStyle(
                                              'Delete',
                                              Colors.white,
                                              14.0,
                                            ),
                                            //
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: (arrNotificationList[i]
                                                          ['senderImage']
                                                      .toString() ==
                                                  '')
                                              ? Image.asset(
                                                  'assets/icons/avatar.png',
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    25.0,
                                                  ),
                                                  child: Image.network(
                                                    arrNotificationList[i]
                                                            ['senderImage']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                        /* trailing: IconButton(
                                              onPressed: () {
                                                //
                                                deleteNotificationPopup(
                                                  context,
                                                  arrNotificationList[index]
                                                          ['notificationid']
                                                      .toString(),
                                                );
                                                //
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.redAccent,
                                              ),
                                            ),*/
                                        title: textWithRegularStyle(
                                          //
                                          arrNotificationList[i]['message']
                                              .toString()
                                              .capitalize,
                                          //
                                          Colors.black,
                                          16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      //
                      Container(
                        height: 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                      // ], //
                    ],
                  )
                ]
              ],
            ),
          )

          /*CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: textWithRegularStyle(
                  'Notifications',
                  Colors.white,
                  18.0,
                ),
                background: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'assets/images/1024_no_bg.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              backgroundColor: navigationColor,
            ),
           
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: arrNotificationList.length,
                (BuildContext context, int index) {
                  if (index == arrNotificationList.length - 1) {
                    return (strRefreshLoader == 'refresh')
                        ? AlertDialog(
                            backgroundColor: Colors.redAccent,
                            // title: textWithBoldStyle(
                            //   'Alert',
                            //   Colors.white,
                            //   18.0,
                            // ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.transparent,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  //
                                ),
                                //
                                const SizedBox(
                                  width: 20,
                                ),
                                //
                                textWithRegularStyle(
                                  'refreshing...',
                                  Colors.white,
                                  14.0,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox();
                  }
                  return (strLoaderAndMessage == '0')
                      ? Center(
                          child: textWithRegularStyle(
                            'No data found',
                            Colors.black,
                            14.0,
                          ),
                        )
                      : Column(
                          children: [
                            //
                            const SizedBox(
                              height: 10,
                            ),
                            // for (int i = 0;
                            // i < arrNotificationList.length;
                            // i++) ...[
                            (arrNotificationList[index]['messagejson']['type']
                                        .toString() ==
                                    'friend_send')
                                ? friendRequestUI(context, index)
                                : (arrNotificationList[index]['messagejson']
                                                ['type']
                                            .toString() ==
                                        'friend_accept')
                                    ? acceptedYourFriendReequestUI(index)
                                    : GestureDetector(
                                        //
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationDetailsScreen(
                                                dictGetPostId:
                                                    arrNotificationList[index],
                                                strPostType:
                                                    arrNotificationList[index]
                                                                ['messagejson']
                                                            ['type']
                                                        .toString(),
                                              ),
                                            ),
                                          );
                                          //
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Dismissible(
                                            direction:
                                                DismissDirection.endToStart,
                                            resizeDuration: const Duration(
                                                microseconds: 100),
                                            key: ObjectKey(
                                              arrNotificationList[index],
                                            ),
                                            onDismissed: (direction) {
                                              //
                                              funcDeleteAfterAccept(
                                                arrNotificationList[index]
                                                        ['notificationid']
                                                    .toString(),
                                              );
                                              //
                                            },
                                            background: Container(
                                              padding: const EdgeInsets.only(
                                                left: 28.0,
                                              ),
                                              color: Colors.redAccent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.white,
                                                  ),
                                                  textWithRegularStyle(
                                                    'Delete',
                                                    Colors.white,
                                                    14.0,
                                                  ),
                                                  //
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: (arrNotificationList[
                                                                    index]
                                                                ['senderImage']
                                                            .toString() ==
                                                        '')
                                                    ? Image.asset(
                                                        'assets/icons/avatar.png',
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25.0,
                                                        ),
                                                        child: Image.network(
                                                          arrNotificationList[
                                                                      index][
                                                                  'senderImage']
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              ),
                                              /* trailing: IconButton(
                                              onPressed: () {
                                                //
                                                deleteNotificationPopup(
                                                  context,
                                                  arrNotificationList[index]
                                                          ['notificationid']
                                                      .toString(),
                                                );
                                                //
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.redAccent,
                                              ),
                                            ),*/
                                              title: textWithRegularStyle(
                                                //
                                                arrNotificationList[index]
                                                        ['message']
                                                    .toString()
                                                    .capitalize,
                                                //
                                                Colors.black,
                                                16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            //
                            Container(
                              height: 0.4,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black,
                            ),
                            // ], //
                          ],
                        );
                },
              ),
            ),
          ],
        ),*/
          ),
      /**/
    );
  }

  ListTile acceptedYourFriendReequestUI(int i) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: (arrNotificationList[i]['senderImage'].toString() == '')
            ? Image.asset(
                'assets/icons/avatar.png',
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                child: Image.network(
                  arrNotificationList[i]['senderImage'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
      ),
      title: textWithRegularStyle(
        //
        arrNotificationList[i]['message'].toString(),
        //
        Colors.black,
        16.0,
      ),
    );
  }

  Padding friendRequestUI(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          children: [
            //
            const SizedBox(
              width: 14,
            ),
            //
            (arrNotificationList[i]['senderImage'].toString() == '')
                ? SizedBox(
                    height: 50,
                    child: Image.asset(
                      'assets/icons/avatar.png',
                    ),
                  )
                : SizedBox(
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      child: Image.network(
                        arrNotificationList[i]['senderImage'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            //
            const SizedBox(
              width: 14,
            ),
            //
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWithBoldStyle(
                  //
                  arrNotificationList[i]['message'].toString(),
                  //
                  Colors.black,
                  16.0,
                ),
                //
                Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //
                        acceptFriendRequest(context, i);
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textWithBoldStyle(
                            'Accept',
                            Colors.black,
                            16.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    const SizedBox(
                      width: 20,
                    ),
                    //
                    GestureDetector(
                      onTap: () {
                        //
                        declineFriendWB(
                          arrNotificationList[i]['messagejson']['senderId']
                              .toString(),
                          arrNotificationList[i]['notificationid'].toString(),
                        );
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Center(
                          child: textWithBoldStyle(
                            'Decline',
                            Colors.white,
                            16.0,
                          ),
                        ),
                      ),
                    ),
                    //
                  ],
                ),
                //
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  notificationListWB(pageNumber) async {
    //
    showLoadingUI(context, 'please wait...');
    //
    if (kDebugMode) {
      print('=====> POST : NOTIFICATION LIST');
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
          'action': 'notificationlist',
          'userId': strGetUserId.toString(),
          'pageNo': pageNumber
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
        // success
        for (Map i in getData['data']) {
          arrNotificationList.add(i);
        }

        if (arrNotificationList.isEmpty) {
          strLoaderAndMessage = '0';
        } else {
          strLoaderAndMessage = '1';
        }

        // if (kDebugMode) {
        //   print(arrNotificationList);
        // }

        Navigator.pop(context);
        setState(() {});

        //
      } else {
        if (kDebugMode) {}
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Something went wrong. Please try again later.'.toString(),
        );
      }
    } else {
      // return postList;
    }
  }

  //
  void deleteNotificationPopup(BuildContext context, notificationId) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: textWithBoldStyle(
          //
          'Delete this notification ?',
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

              funcDeleteAfterAccept(
                notificationId.toString(),
              );
              //
            },
            child: textWithBoldStyle(
              //
              "Yes, delete",
              //
              Colors.redAccent,
              18.0,
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
  void acceptFriendRequest(BuildContext context, i) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: textWithBoldStyle(
          //
          'Are you sure you want to add "${arrNotificationList[i]['senderName']}" as a friend ?',
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
              acceptFriendWB(
                arrNotificationList[i]['messagejson']['senderId'].toString(),
                arrNotificationList[i]['notificationid'].toString(),
              );
              //
            },
            child: textWithBoldStyle(
              //
              "Yes, accept",
              //
              Colors.green,
              18.0,
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

  //
  acceptFriendWB(senderId, getNotificationId) async {
    if (kDebugMode) {
      print('=====> POST : ACCEPT FRIEND REQUEST');
    }

    showLoadingUI(context, 'accepting...');

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'sendacceptfriend',
          'userId': strGetUserId.toString(),
          'profileId': senderId.toString(),
          'status': '2',
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
        arrNotificationList.clear();
        //
        Navigator.pop(context);
        notificationListWB(1);
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  // decline
  //
  declineFriendWB(
    profileId,
    getNotificationId,
  ) async {
    if (kDebugMode) {
      print('=====> POST : DECLINE FRIEND REQUEST');
    }

    showLoadingUI(context, 'declining...');

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'frienddecline',
          'userId': strGetUserId.toString(),
          'profileId': profileId.toString(),
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
        funcDeleteAfterAccept(getNotificationId);
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  //
  funcDeleteAfterAccept(notificationId) async {
    if (kDebugMode) {
      print('DELETE NOTIFICATION');
    }
    //
    showLoadingUI(context, 'deleting...');
    //
    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'deletenotification',
          'userId': strGetUserId.toString(),
          'notificationId': notificationId.toString(),
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
        arrNotificationList.clear();
        //
        notificationListWB(1);
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
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }
}
