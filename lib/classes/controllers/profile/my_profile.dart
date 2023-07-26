// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
// import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:pludin/classes/controllers/chat/chat.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_comment/home_feeds_comments.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_text_UI/home_feeds_text_UI.dart';
import 'package:pludin/classes/controllers/home/home_like_modal/home_like_modal.dart';
// import 'package:pludin/classes/controllers/menu/menu.dart';
import 'package:pludin/classes/controllers/profile/my_profile_feeds/my_profile_feeds.dart';
import 'package:pludin/classes/controllers/profile/my_profile_modal/my_profile_modal.dart';
import 'package:pludin/classes/controllers/profile/profile_gallery/photo_gallery_modal/photo_gallery_modal.dart';
import 'package:pludin/classes/controllers/profile/profile_gallery/profile_gallery.dart';
// import 'package:pludin/classes/controllers/profile/profile_gallery/profile_gallery.dart';
// import 'package:pludin/classes/controllers/profile/profile_gallery/profile_gallery.dart';
import 'package:pludin/classes/controllers/profile/profile_videos/profile_videos.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../database/database_helper.dart';

import 'package:http_parser/http_parser.dart';

// import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key, required this.strUserId});

  final String strUserId;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  //
  final homeLikeUnlikeApiCall = HomeLikeModal();
  //
  var fetchedAllData;
  //
  var strLikePress = '0';
  //
  var strSelectStatus = '0';
  //
  var screenLoader = '0';
  var strClickFeed = '1';
  var strClickImages = '0';
  var strClickVideos = '0';
  var strAddFriendLoader = '1'; // bydefault 1

  var strLoginUserId = '';
  var dismissPopup = '0';
  //
  var arrImageList = [];
  //
  late DataBase handler;
  //
  final userGalleryApiCall = UserGalleryModal();
  final userProfileApiCall = UserProfileModal();
  //
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //

  final ImagePicker imagePicker = ImagePicker();
  //
  File? imageFile;
  List<XFile>? imageFileList = [];
  //
  var strUserHitType = '1';
  //
  List<String> arr_scroll_multiple_images = [];
  //
  var strUserSetProfileForOthers = '0';
  var strIsThisUserAFriend = '0';
  //
  @override
  void initState() {
    super.initState();
    //
    handler = DataBase();
    //
    funcGetLocalDBdata();

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
            print('YES, LOCAL DB HAVE SOME DATA in profile screen');
          }
          //

          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    print('LOGIN USER ID  ====> $strLoginUserId'),
                    print(widget.strUserId),
                    // print(widget.strUserId),
                    //
                  },
                //
                userProfileApiCall
                    .userProfileWB(
                      widget.strUserId.toString(),
                      strLoginUserId.toString(),
                    )
                    .then((value) => {
                          // print('me call'),

                          setState(() {
                            screenLoader = '1';
                            // print(value['data']);
                            fetchedAllData = value['data'];
                            if (kDebugMode) {
                              print('qwerty =======================>');
                              print(fetchedAllData);
                              print(widget.strUserId);
                            }
                          })
                        }),
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
      key: scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: (screenLoader == '0')
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      //
                      if (fetchedAllData['friendStatus'].toString() == '2') ...[
                        if (fetchedAllData['ProfilePicture_setting']
                                .toString() ==
                            '3') ...[
                          // friends : only me ( full profile )
                          (widget.strUserId == strLoginUserId)
                              ? (fetchedAllData['image'].toString() == '')
                                  ? //
                                  onlyPlaceholderImageShowUI(context)
                                  //
                                  : Container(
                                      color: Colors.black,
                                      width: MediaQuery.of(context).size.width,
                                      height: 260,
                                      child: Opacity(
                                        opacity: 0.4,
                                        child: Image.network(
                                          //
                                          fetchedAllData['image'].toString(),
                                          fit: BoxFit.cover,
                                          //
                                        ),
                                      ),
                                    )
                              : //
                              onlyPlaceholderImageShowUI(context)
                          //
                        ] else if (fetchedAllData['ProfilePicture_setting']
                                    .toString() ==
                                '2' ||
                            (fetchedAllData['ProfilePicture_setting']
                                    .toString() ==
                                '1')) ...[
                          (fetchedAllData['image'].toString() == '')
                              ? //
                              onlyPlaceholderImageShowUI(context)
                              //
                              : Container(
                                  color: Colors.black,
                                  width: MediaQuery.of(context).size.width,
                                  height: 260,
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Image.network(
                                      //
                                      fetchedAllData['image'].toString(),
                                      fit: BoxFit.cover,
                                      //
                                    ),
                                  ),
                                ),
                        ],
                      ] else ...[
                        // this user is not a friend

                        if (fetchedAllData['ProfilePicture_setting']
                                .toString() ==
                            '1') ...[
                          (fetchedAllData['image'].toString() == '')
                              ? //
                              onlyPlaceholderImageShowUI(context)
                              //
                              : Container(
                                  color: Colors.black,
                                  width: MediaQuery.of(context).size.width,
                                  height: 260,
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Image.network(
                                      //
                                      fetchedAllData['image'].toString(),
                                      fit: BoxFit.cover,
                                      //
                                    ),
                                  ),
                                ),
                        ] else ...[
                          //
                          onlyPlaceholderImageShowUI(context)
                          //
                        ]
                      ],

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50.0),
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            height: 48.0,
                            // child: widget
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      scaffoldKey.currentState!.openDrawer(),
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                                //
                                Expanded(
                                  // flex: 2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: textWithBoldStyle(
                                      'Profile',
                                      Colors.white,
                                      20.0,
                                    ),
                                  ),
                                ),
                                //
                                (fetchedAllData['userId'].toString() ==
                                        strLoginUserId.toString())
                                    ? const SizedBox(
                                        height: 0,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('menu click');
                                          }
                                          // success
                                          QuickAlert.show(
                                            context: context,
                                            barrierColor: Colors.blueGrey,
                                            type: QuickAlertType.confirm,
                                            text:
                                                'Do you want to block this user ?',
                                            confirmBtnText: 'Yes',
                                            cancelBtnText: 'No',
                                            confirmBtnColor: Colors.green,
                                            onConfirmBtnTap: () {
                                              if (kDebugMode) {
                                                print('some click');
                                              }
                                              //
                                              blockUserWB(
                                                  fetchedAllData['userId']
                                                      .toString());
                                              //
                                            },
                                          );
                                          //
                                        },
                                        icon: const Icon(
                                          Icons.block,
                                          color: Colors.red,
                                        ),
                                      ),
                                if (strSelectStatus == '0') ...[
                                  //
                                  // IconButton(onPressed: (), icon: icon)
                                  //
                                ] else if (strSelectStatus == '1') ...[
                                  (widget.strUserId == strLoginUserId)
                                      ? const SizedBox(
                                          height: 0,
                                          width: 0,
                                        )
                                      /*SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: NeoPopButton(
                                            color: Colors.white,
                                            onTapUp: () {
                                              //
                                              selectImages();
                                              //
                                            },
                                            onTapDown: () =>
                                                HapticFeedback.vibrate(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                textWithBoldStyle(
                                                  'Add Photos',
                                                  Colors.green,
                                                  14.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )*/
                                      : const SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  //
                                ] else if (strSelectStatus == '2') ...[
                                  (widget.strUserId == strLoginUserId)
                                      ? SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: NeoPopButton(
                                            color: Colors.white,
                                            onTapUp: () {
                                              //
                                              selectVideos();
                                              //
                                            },
                                            onTapDown: () =>
                                                HapticFeedback.vibrate(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                textWithBoldStyle(
                                                  'Add Videos',
                                                  Colors.green,
                                                  14.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  //
                                ],

                                const SizedBox(
                                  width: 20,
                                ),
                                //
                              ],
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(left: 10, top: 100.0),
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Row(
                              children: [
                                if (fetchedAllData['friendStatus'].toString() ==
                                    '2') ...[
                                  if (fetchedAllData['ProfilePicture_setting']
                                          .toString() ==
                                      '3') ...[
                                    // friends : only me ( full profile )
                                    (widget.strUserId == strLoginUserId)
                                        ? (fetchedAllData['image'].toString() ==
                                                '')
                                            ? //
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0.0),
                                                width: 54,
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                      'assets/icons/avatar.png',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  color: Colors.pink[600],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    27.0,
                                                  ),
                                                ),
                                              )
                                            //
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0.0),
                                                width: 54,
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  color: Colors.pink[600],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    27.0,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    27,
                                                  ),
                                                  child: Image.network(
                                                    //
                                                    fetchedAllData['image']
                                                        .toString(),
                                                    height: 27,
                                                    width: 27,
                                                    fit: BoxFit.cover,
                                                    //
                                                  ),
                                                ),
                                              )
                                        : //
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 0.0),
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/avatar.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Colors.pink[600],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27.0,
                                              ),
                                            ),
                                          )
                                    //
                                  ] else if (fetchedAllData[
                                                  'ProfilePicture_setting']
                                              .toString() ==
                                          '2' ||
                                      (fetchedAllData['ProfilePicture_setting']
                                              .toString() ==
                                          '1')) ...[
                                    (fetchedAllData['image'].toString() == '')
                                        ? //
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 0.0),
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/avatar.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Colors.pink[600],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27.0,
                                              ),
                                            ),
                                          )
                                        //
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                left: 0.0),
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              color: Colors.pink[600],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27.0,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27,
                                              ),
                                              child: Image.network(
                                                //
                                                fetchedAllData['image']
                                                    .toString(),
                                                height: 27,
                                                width: 27,
                                                fit: BoxFit.cover,
                                                //
                                              ),
                                            ),
                                          ),
                                  ],
                                ] else ...[
                                  // this user is not a friend

                                  if (fetchedAllData['ProfilePicture_setting']
                                          .toString() ==
                                      '1') ...[
                                    (fetchedAllData['image'].toString() == '')
                                        ? //
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 0.0),
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/avatar.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Colors.pink[600],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27.0,
                                              ),
                                            ),
                                          )
                                        //
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                left: 0.0),
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              color: Colors.pink[600],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27.0,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                27,
                                              ),
                                              child: Image.network(
                                                //
                                                fetchedAllData['image']
                                                    .toString(),
                                                height: 27,
                                                width: 27,
                                                fit: BoxFit.cover,
                                                //
                                              ),
                                            ),
                                          ),
                                  ] else ...[
                                    //
                                    Container(
                                      margin: const EdgeInsets.only(left: 0.0),
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/icons/avatar.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        color: Colors.pink[600],
                                        borderRadius: BorderRadius.circular(
                                          27.0,
                                        ),
                                      ),
                                    )
                                    //
                                  ]
                                ],
                                /*(fetchedAllData['image'].toString() == '')
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(left: 0.0),
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage(
                                              'assets/icons/avatar.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          color: Colors.pink[600],
                                          borderRadius: BorderRadius.circular(
                                            27.0,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(left: 0.0),
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: Colors.pink[600],
                                          borderRadius: BorderRadius.circular(
                                            27.0,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            27,
                                          ),
                                          child: Image.network(
                                            //
                                            fetchedAllData['image'].toString(),
                                            height: 27,
                                            width: 27,
                                            fit: BoxFit.cover,
                                            //
                                          ),
                                        ),
                                      ),*/
                                //
                                Container(
                                  color: Colors.transparent,
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textWithBoldStyle(
                                        //
                                        fetchedAllData['fullName'].toString(),
                                        //
                                        Colors.white,
                                        18.0,
                                      ),
                                      //
                                      textWithRegularStyle(
                                        //
                                        '@${fetchedAllData['fullName']}',
                                        //
                                        const Color.fromRGBO(
                                          112,
                                          209,
                                          214,
                                          1,
                                        ),
                                        14.0,
                                      ),
                                      //
                                    ],
                                  ),
                                ),
                                //
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            // width: 48.0,
                            height: 48.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textWithBoldStyle(
                                  //
                                  fetchedAllData['totalPost'].toString(),
                                  //
                                  Colors.black,
                                  16.0,
                                ),
                                //
                                textWithRegularStyle(
                                  'Posts',
                                  Colors.black,
                                  16.0,
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                        //
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            // width: 48.0,
                            height: 48.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textWithBoldStyle(
                                  //
                                  fetchedAllData['FriendCount'].toString(),
                                  //
                                  Colors.black,
                                  16.0,
                                ),
                                //
                                textWithRegularStyle(
                                  'Friends',
                                  Colors.black,
                                  16.0,
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                        //

                        if (widget.strUserId == strLoginUserId) ...[
                          //

                          //
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(
                                  232,
                                  50,
                                  116,
                                  1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  24.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  textWithBoldStyle(
                                    ' Search Friend',
                                    Colors.white,
                                    16.0,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ] else ...[
                          // another user's profile
                          (strAddFriendLoader == '0')
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : (fetchedAllData['friendStatus'].toString() ==
                                      '2')
                                  ? Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () {
                                          //
                                          if (kDebugMode) {
                                            print(FirebaseAuth
                                                .instance.currentUser!.uid);
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                chatDialogData: fetchedAllData,
                                                strFromDialog: 'no',
                                              ),
                                            ),
                                          );

                                          //
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              24.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.chat,
                                                color: Colors.white,
                                              ),
                                              textWithBoldStyle(
                                                ' Chat',
                                                Colors.white,
                                                16.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : (fetchedAllData['friendStatus']
                                              .toString() ==
                                          '')
                                      ? Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: () {
                                              //
                                              addFriendWB();
                                              //
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                  232,
                                                  50,
                                                  116,
                                                  1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  24.0,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  textWithBoldStyle(
                                                    ' Add Friend',
                                                    Colors.white,
                                                    16.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : (fetchedAllData['friendUserId']
                                                  .toString() ==
                                              strLoginUserId.toString())
                                          ? Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    24.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // const Icon(
                                                    //   Icons.add,
                                                    //   color: Colors.white,
                                                    // ),
                                                    textWithBoldStyle(
                                                      ' Friend Request sent',
                                                      Colors.white,
                                                      14.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: () {
                                                  //
                                                  if (kDebugMode) {
                                                    print('accept request');
                                                  }
                                                  //
                                                  acceptFriendWB();
                                                  //
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      24.0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // const Icon(
                                                      //   Icons.add,
                                                      //   color: Colors.white,
                                                      // ),
                                                      textWithBoldStyle(
                                                        ' Accept request',
                                                        Colors.white,
                                                        16.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                        ],

                        //
                      ],
                    ),
                  ),
                  //
                  if (fetchedAllData['friendStatus'].toString() == '2') ...[
                    if (fetchedAllData['Profile_setting'].toString() ==
                        '3') ...[
                      // friends : only me ( full profile )
                      showLockUI(context)
                    ] else if (fetchedAllData['Profile_setting'].toString() ==
                            '2' ||
                        (fetchedAllData['Profile_setting'].toString() ==
                            '1')) ...[
                      threeButtonsSelectForProfile(context)
                    ],
                  ] else ...[
                    // this user is not a friend

                    if (fetchedAllData['Profile_setting'].toString() ==
                        '1') ...[
                      threeButtonsSelectForProfile(context)
                    ] else ...[
                      showLockUI(context),
                    ]
                  ], //
                  if (strClickFeed == '1') ...[
                    //
                    (fetchedAllData['friendStatus'].toString() == '2')
                        ? MyProfileFeeds(
                            strFetchUserId: strLoginUserId.toString(),
                            strFetchFriendUserId:
                                fetchedAllData['userId'].toString(),
                            strCheckIsHeMyFriend: 'yes_friends',
                          )
                        : MyProfileFeeds(
                            strFetchUserId: strLoginUserId.toString(),
                            strFetchFriendUserId:
                                fetchedAllData['userId'].toString(),
                            strCheckIsHeMyFriend: 'no_friends',
                          )

                    //
                    //
                  ] else if (strClickImages == '1') ...[
                    //
                    GridView.builder(
                      padding: const EdgeInsets.all(6),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // maxCrossAxisExtent: 300,
                        childAspectRatio: 6 / 6,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15, crossAxisCount: 3,
                      ),
                      itemCount: arrImageList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            CustomImageProvider customImageProvider =
                                CustomImageProvider(
                                    //
                                    imageUrls:
                                        arr_scroll_multiple_images.toList(),

                                    //
                                    initialIndex: index);
                            showImageViewerPager(context, customImageProvider,
                                doubleTapZoomable: true, onPageChanged: (page) {
                              // print("Page changed to $page");
                            }, onViewerDismissed: (page) {
                              // print("Dismissed while on page $page");
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                // left: 10.0,
                                // right: 10,
                                ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(
                                240,
                                240,
                                240,
                                1,
                              ),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    //
                                    arrImageList[index]['image'].toString()
                                    //
                                    ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child:
                          ),
                        );
                      },
                    )

                    //
                  ] else ...[
                    //
                    ProfileVideosScreen(
                      sendData: arrImageList,
                    )
                    //
                  ],
                ],
              ),
            ),
    );
  }

  Container onlyPlaceholderImageShowUI(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 260,
      child: Image.asset(
        'assets/icons/avatar.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Padding showLockUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        20.0,
      ),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: const Icon(
          Icons.lock,
          size: 40.0,
        ),
      ),
    );
  }

  Container threeButtonsSelectForProfile(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(10.0),
      color: const Color.fromRGBO(
        231,
        231,
        231,
        1,
      ),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (kDebugMode) {
                  print('click feeds =====> $strClickFeed');
                  print(fetchedAllData);
                }
                //
                strSelectStatus = '0';

                //
                setState(() {
                  if (strClickFeed == '0') {
                    strClickFeed = '1';
                    strClickImages = '0';
                    strClickVideos = '0';
                  } else {
                    // strClickFeed = '0';
                    strClickImages = '0';
                    strClickVideos = '0';
                  }
                });
                //
              },
              child: (strClickFeed == '0')
                  ? SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/option_black.png',
                      ),
                    )
                  : SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/option_color.png',
                      ),
                    ),
            ),
          ),
          //
          Expanded(
            child: InkWell(
              onTap: () {
                if (kDebugMode) {
                  print('click images =====> $strClickImages');
                }
                //
                setState(() {
                  strUserHitType = '1';
                });
                funcLoadAllImages('Image');
                //
                setState(() {
                  strSelectStatus = '1';
                  if (strClickImages == '0') {
                    strClickImages = '1';
                    strClickFeed = '0';
                    strClickVideos = '0';
                  } else {
                    // strClickImages = '0';
                    strClickFeed = '0';
                    strClickVideos = '0';
                  }
                });
                //
              },
              child: (strClickImages == '0')
                  ? SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/profile_image_black.png',
                      ),
                    )
                  : SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/profile_image_color.png',
                      ),
                    ),
            ),
          ),
          //
          Expanded(
            child: InkWell(
              onTap: () {
                if (kDebugMode) {
                  print('click video =====> $strClickVideos');
                }
                //
                //
                setState(() {
                  strUserHitType = '2';
                });
                funcLoadAllImages('Video');

                //
                setState(() {
                  if (strClickVideos == '0') {
                    strClickVideos = '1';
                    strClickFeed = '0';
                    strClickImages = '0';
                  } else {
                    // strClickVideos = '0';
                    strClickFeed = '0';
                    strClickImages = '0';
                  }
                });
                //
              },
              child: (strClickVideos == '0')
                  ? SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/profile_video_black.png',
                      ),
                    )
                  : SizedBox(
                      height: 26,
                      width: 26,
                      child: Image.asset(
                        'assets/icons/profile_video_color.png',
                      ),
                    ),
            ),
          ),
          //
        ],
      ),
    );
  }

  //
  // select multiple images
  void selectImages() async {
    //
    imageFileList!.clear();
    //
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    // imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    /*setState(() {
      str_user_profile_loader = '0';
    });*/

    if (kDebugMode) {
      print("Image List Length: =====> ${imageFileList!.last}");
      print("Image List Length: =====> ${imageFileList!.length}");
    }

    uploadImageToServer();
  }

  // select multiple images
  void selectVideos() async {
    //
    PickedFile? pickedFile = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      // maxWidth: 1800,
      // maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        if (kDebugMode) {
          print('object');
        }
        // when user select photo from gallery
        // strPostType = '2';
        // hide send button for text
        // strTextCount = '0';
        //
        imageFile = File(pickedFile.path);
      });
      //
      uploadVideoToServer();
      //
    }
  }

//
  uploadVideoToServer() async {
    // UPLOAD DATA WITH IMAGE
    // uploadImageWithOrWithoutText() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // strPostType = 'loader';
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    request.fields['action'] = 'addphotoIOS';

    request.fields['userId'] = strLoginUserId.toString();

    if (kDebugMode) {
      print('check');
    }

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    if (kDebugMode) {
      print(responsedData);
    }

    if (responsedData['status'].toString().toLowerCase() == 'success') {
      imageFile = null;

      if (kDebugMode) {
        print('success');
      }
      //
      /*arrHomePosts.clear();
      //
      contWriteSomething.text = '';
      strPostType = '1';
      strTextCount = '0';

      //
      funcSendUserIdToGetHomeData(
        strGetUserId.toString(),
      );*/
      //
    } else {
      // setState(() {
      //   strPostType =
      //       '1'; // remove circular progress bar after successfully load
      // });
    }

    //
    // }
  }

  //
  uploadImageToServer() async {
    // setState(() {});

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    //
    dismissPopup = '1';
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'uploading...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    request.fields['action'] = 'addphotoIOS';
    request.fields['userId'] = strLoginUserId.toString();

    if (kDebugMode) {
      // print('dishant rajput');
      // print(imageFileList!);
    }

    // List<http.MultipartFile> newList = [];

    // List<http.MultipartFile> newList = [];

    // 1
    for (int i = 0; i < imageFileList!.length; i++) {
      // print(i);
      request.files.add(
        http.MultipartFile(
          'multiImage.'
          '$i',
          File(imageFileList![i].path).readAsBytes().asStream(),
          File(imageFileList![i].path).lengthSync(),
          filename: (imageFileList![i].path.split("/").last),
          contentType: MediaType('multiImage', 'png'),
        ),
      );
      // newList.add(request as http.MultipartFile);
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    if (kDebugMode) {
      print(responsedData);
    }

    if (responsedData['status'].toString() == 'Success'.toLowerCase()) {
      //
      // setState(() {
      //   dummy = '1';
      //   strClickImages = '1';
      //   // str_user_profile_loader = '0';
      //   // print(strClickImages);
      // });
      // // profile_details_WB();

      //
      // funcLoadAllImages();
      //
    }
  }

  //
  funcLoadAllImages(
    strGetType,
  ) {
    userGalleryApiCall
        .userGallertWB(widget.strUserId.toString(), strGetType.toString())
        .then((value1) => {
              // print(value1),
              setState(() {
                arrImageList = value1;

                if (dismissPopup != '0') {
                  Navigator.pop(context);
                  dismissPopup = '0';
                }

                if (kDebugMode) {
                  print(arrImageList);
                  print(arrImageList.length);
                }
                for (int i = 0; i < arrImageList.length; i++) {
                  // print(arrImageList[i]);
                  arr_scroll_multiple_images.add(arrImageList[i]['image']);
                }
              })
            });
  }

  //
  //
  addFriendWB() async {
    if (kDebugMode) {
      print('=====> POST : ADD COMMENT');
    }

    setState(() {
      strAddFriendLoader = '0';
    });

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
          'userId': strLoginUserId.toString(),
          'profileId': widget.strUserId.toString(),
          'status': '1',
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

        userProfileApiCall
            .userProfileWB(
              widget.strUserId.toString(),
              strLoginUserId.toString(),
            )
            .then((value) => {
                  // print('me call'),

                  setState(() {
                    screenLoader = '1';
                    strAddFriendLoader = '1';
                    // print(value['data']);
                    fetchedAllData = value['data'];
                  })
                });

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
  //
  acceptFriendWB() async {
    if (kDebugMode) {
      print('=====> POST : ACCEPT FRIEND REQUEST');
    }

    setState(() {
      strAddFriendLoader = '0';
    });

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
          'userId': strLoginUserId.toString(),
          'profileId': widget.strUserId.toString(),
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

        userProfileApiCall
            .userProfileWB(
              widget.strUserId.toString(),
              strLoginUserId.toString(),
            )
            .then((value) => {
                  // print('me call'),

                  setState(() {
                    screenLoader = '1';
                    strAddFriendLoader = '1';
                    // print(value['data']);
                    fetchedAllData = value['data'];
                  })
                });

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
  // upload feeds data to time line
  blockUserWB(
    strGetFriendIdIs,
  ) async {
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'blocking...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    if (kDebugMode) {
      print('=====> POST : UPLOAD ONLY TEXT ');
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
          'action': 'block_unblock_friend',
          'userId': strLoginUserId.toString(),
          'profileId': strGetFriendIdIs.toString(),
          'status': '1',
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: getData['msg'],
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            //
            Navigator.pushNamed(context, 'push_to_home_screen');
            //
          },
        );
        //
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
