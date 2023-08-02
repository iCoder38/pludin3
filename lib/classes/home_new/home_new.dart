// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pludin/classes/controllers/database/database_modal.dart';
import 'package:pludin/classes/home_new/home_new_comments/home_new_comments.dart';
import 'package:pludin/classes/home_new/home_new_image/home_new_image.dart';
import 'package:pludin/classes/home_new/home_new_shared_image/home_new_shared_image.dart';
import 'package:pludin/classes/home_new/home_new_shared_map/home_new_shared_map_ui.dart';
import 'package:pludin/classes/home_new/home_new_shared_text/home_new_shared_text.dart';
import 'package:pludin/classes/home_new/home_new_shared_video/home_new_shared_video_ui.dart';
import 'package:pludin/classes/home_new/home_new_simple_text_UI/home_new_simple_text_ui.dart';
import 'package:pludin/classes/home_new/home_new_video_ui/home_new_video_ui.dart';
import 'package:pludin/classes/user_profile_new/user_profile_new.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:readmore/readmore.dart';

import '../controllers/database/database_helper.dart';
import '../controllers/drawer/drawer.dart';
import '../controllers/home/home_like_modal/home_like_modal.dart';
import '../controllers/home/home_modal/home_modal.dart';
import '../controllers/profile/profile_gallery/profile_gallery.dart';
import '../header/utils.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'home_new_map/home_new_map.dart';
import 'home_new_play_video/home_new_play_video.dart';

class HomeNewScreen extends StatefulWidget {
  const HomeNewScreen({super.key});

  @override
  State<HomeNewScreen> createState() => _HomeNewScreenState();
}

class _HomeNewScreenState extends State<HomeNewScreen> {
  //
  late final TextEditingController contWriteSomething;
  //
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late DataBase handler;
  //
  //
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  //
  // save all feeds in array list
  var arrHomePosts = [];
  //
  // login user data var
  var strGetUserId = '';
  var strLoginUserImage = '';
  //
  // page control
  var pageControl = 1;
  //
  // home api modal
  final homeApiCall = HomeModal();
  //
  final homeLikeUnlikeApiCall = HomeLikeModal();

  var strLikepopupDismiss = '0';
  var strReportPostPopupDismiss = '0';
  var strHideWhenPaginationDone = '0';
  var strReCreateHomePage = '0';
  var strGetUserDeviceToken = '';

  var strPlayPause = '0';

  var strUploadVideoLoader = '0';

  var strGridCount = 0;

  // action sheet
  File? thumbNailImageFile;
  File? imageFile;
  ImagePicker picker = ImagePicker();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  // final ImagePicker imagePicker = ImagePicker();
  // List<XFile>? imageFileList = [];

// map
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  var strSharedLat = '';
  var strSharedLong = '';
  var strLoadingWhenUserCameBackToDashboard = '0';
  //
  late int currentIndex;
  var strImageCount = 0;
  List<String> arrScrollMultipleImages = [];
  //
  @override
  void initState() {
    //
    handler = DataBase();
    //
    contWriteSomething = TextEditingController();
    //
    funcGetLocalDBdata();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    contWriteSomething.dispose();
    //
    super.dispose();
  }

  // GET HOME FEEDS DATA => WB
  funcSendUserIdToGetHomeData(
    strLoginUserId,
    strBack,
    pageControlIs,
  ) {
    homeApiCall
        .homeWB(
      strLoginUserId.toString(),
      'Other',
      pageControlIs,
    )
        .then((value1) {
      //

      funcCreateMyOwnCustomResponse(value1);

      //
    });
  }

  // create my own custom class
  funcCreateMyOwnCustomResponse(getResponseFromServer) {
    if (kDebugMode) {
      print('=========== RESPONSE =============');
      print(getResponseFromServer);
      print(getResponseFromServer.length);
      print('==================================');
      print('==================================');
    }
    //
    Map<String, dynamic> data;
    // print(arrHomePosts.length);

    for (int i = 0; i < getResponseFromServer.length; i++) {
      if (getResponseFromServer[i]['youliked'].toString() == 'Yes') {
        data = {
          'postId': getResponseFromServer[i]['postId'].toString(),
          'userId': getResponseFromServer[i]['userId'].toString(),
          'message': getResponseFromServer[i]['message'].toString(),
          'postType': getResponseFromServer[i]['postType'].toString(),
          'created': getResponseFromServer[i]['created'].toString(),
          'timeZone': getResponseFromServer[i]['timeZone'].toString(),
          'fullName': getResponseFromServer[i]['fullName'].toString(),
          'lastName': getResponseFromServer[i]['lastName'].toString(),
          'email': getResponseFromServer[i]['email'].toString(),
          'contactNumber': getResponseFromServer[i]['contactNumber'].toString(),
          'status': getResponseFromServer[i]['status'].toString(),
          'SettingProfile':
              getResponseFromServer[i]['SettingProfile'].toString(),
          'SettingProfilePicture':
              getResponseFromServer[i]['SettingProfilePicture'].toString(),
          'Userimage': getResponseFromServer[i]['Userimage'].toString(),
          'postImage': getResponseFromServer[i]['postImage'],
          'share': getResponseFromServer[i]['share'],
          'likesCount': getResponseFromServer[i]['likesCount'],
          'youliked': getResponseFromServer[i]['youliked'].toString(),
          'friendStatus': getResponseFromServer[i]['friendStatus'].toString(),
          'like_status': 'yes'
        };
      } else {
        data = {
          'postId': getResponseFromServer[i]['postId'].toString(),
          'userId': getResponseFromServer[i]['userId'].toString(),
          'message': getResponseFromServer[i]['message'].toString(),
          'postType': getResponseFromServer[i]['postType'].toString(),
          'created': getResponseFromServer[i]['created'].toString(),
          'timeZone': getResponseFromServer[i]['timeZone'].toString(),
          'fullName': getResponseFromServer[i]['fullName'].toString(),
          'lastName': getResponseFromServer[i]['lastName'].toString(),
          'email': getResponseFromServer[i]['email'].toString(),
          'contactNumber': getResponseFromServer[i]['contactNumber'].toString(),
          'status': getResponseFromServer[i]['status'].toString(),
          'SettingProfile':
              getResponseFromServer[i]['SettingProfile'].toString(),
          'SettingProfilePicture':
              getResponseFromServer[i]['SettingProfilePicture'].toString(),
          'Userimage': getResponseFromServer[i]['Userimage'].toString(),
          'postImage': getResponseFromServer[i]['postImage'],
          'share': getResponseFromServer[i]['share'],
          'likesCount': getResponseFromServer[i]['likesCount'],
          'youliked': getResponseFromServer[i]['youliked'].toString(),
          'friendStatus': getResponseFromServer[i]['friendStatus'].toString(),
          'like_status': 'no'
        };
      }

      //
      // add custom data
      arrHomePosts.add(data);
    }

    //
    setState(() {
      if (strLikepopupDismiss == '1') {
        Navigator.pop(context);
        strLikepopupDismiss = '0';
      }
      //
      if (strHideWhenPaginationDone == '1') {
        Navigator.pop(context);
        strHideWhenPaginationDone = '0';
      }
      //
      if (strReCreateHomePage == '1') {
        Navigator.pop(context);
        strReCreateHomePage = '0';
      }

      if (strUploadVideoLoader == '1') {
        Navigator.pop(context);
        Navigator.pop(context);
        strUploadVideoLoader = '0';
      }

      if (strLoadingWhenUserCameBackToDashboard == '1') {
        Navigator.pop(context);
        strLoadingWhenUserCameBackToDashboard = '0';
      }
    });
    //
    funcGetUserFirestoreId();
    //
  }

  //
  // GET FIRESTOREID TO UPDATE TOKEN
  funcGetUserFirestoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}member")
        .doc("India")
        .collection("details")
        .where("firebaseId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
            // print(element.data()['']);
            // print(element.id.runtimeType);
          }
          //
          //

          // UPDATE DEVICE TOKEN
          FirebaseFirestore.instance
              .collection('${strFirebaseMode}member')
              .doc('India')
              .collection('details')
              .doc(element.id)
              .set(
            {
              'device': 'iOS',
              'deviceToken': prefs.getString('deviceToken').toString(),
            },
            SetOptions(merge: true),
          ).then(
            (value) {
              if (kDebugMode) {
                print('======');
                print(
                    '==========> DONE ALL AND NOW LOGOUT AND LOGIN MAIN COMPANY <==========');
              }
              //

              //
            },
          );
        }
      }
    });

    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          width: 50,
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        backgroundColor: navigationColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                openUploadOptions(context);
              },
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                  border: Border.all(
                    width: 0.8,
                    color: Colors.white,
                  ),
                ),
                child: Center(
                  child: textWithBoldStyle(
                    'Post',
                    Colors.white,
                    18.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: NotificationListener<ScrollEndNotification>(
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
              showLoadingUI(context, 'please wait...');
              strHideWhenPaginationDone = '1';
              //
              pageControl += 1;
              //
              funcSendUserIdToGetHomeData(
                strGetUserId.toString(),
                'no',
                pageControl,
              );
              //
              // });
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //
              for (int i = 0; i < arrHomePosts.length; i++) ...[
                if (arrHomePosts[i]['postType'].toString() == 'Text') ...[
                  //
                  // check is this text is shared or not
                  if (arrHomePosts[i]['share'] == null) ...[
                    simpleTextFeedUI(context, i),
                  ] else ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared some text'),
                    //
                    //
                    HomeNewSharedTextScreen(
                      getDataToShareTextWithIndex: arrHomePosts[i],
                    ),
                    //
                    likeCommentShareUI(context, i, 'yes'),
                    //
                  ]
                ] else if (arrHomePosts[i]['postType'].toString() == 'Map') ...[
                  //
                  // check is this text is shared or not
                  if (arrHomePosts[i]['share'] == null) ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared location'),
                    //
                    // show map on feeds
                    HomeNewMapScreen(getData: arrHomePosts[i]),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'no'),
                  ] else ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared location'),
                    //
                    //
                    //
                    //
                    if (arrHomePosts[i]['message'].split(',')[2] == '')
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ReadMoreText(
                            //
                            arrHomePosts[i]['message'].split(',')[2],
                            //
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                            //
                            trimLines: 3,
                            colorClickableText: Colors.black,
                            lessStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Show more',
                            trimExpandedText: '...Show less',
                            moreStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    HomeNewSharedMapUIScreen(
                      getDataSharedMapUIWithIndex: arrHomePosts[i],
                    ),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'yes'),
                  ]
                ] else if (arrHomePosts[i]['postType'].toString() ==
                    'Image') ...[
                  //
                  // check is this text is shared or not
                  if (arrHomePosts[i]['share'] == null) ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared some image'),
                    //
                    // show images on feeds
                    HomeNewImageScreen(
                        getDataForImageWithIndex: arrHomePosts[i]),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'no'),
                  ] else ...[
                    //
                    //
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared some image'),
                    //
                    //
                    messageWhenUserShareUI(i),
                    //
                    HomeNewShareImageScreen(
                      getDataSharedImageDataWithIndex: arrHomePosts[i],
                    ),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'yes'),
                  ]
                ] else if (arrHomePosts[i]['postType'].toString() ==
                    'Video') ...[
                  //
                  // check is this text is shared or not
                  if (arrHomePosts[i]['share'] == null) ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared some video'),
                    //
                    // show video on feeds
                    HomeNewVideoUIScreen(
                      getDataFroVideoUIWithIndex: arrHomePosts[i],
                    ),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'no'),
                  ] else ...[
                    //
                    // header = > image , name , time
                    commonHeaderForAllCellTypesUI(
                        context, i, ' shared some video'),

                    //
                    messageWhenUserShareUI(i),
                    //
                    //
                    HomeNewSharedVideoScreen(
                      getDataForVideoWithIndex: arrHomePosts[i],
                    ),
                    //
                    // like , comment and share
                    likeCommentShareUI(context, i, 'yes'),
                  ]
                ],
                //
                // create separator
                Container(
                  height: 0.4,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                ),
              ]
              //
            ],
          ),
        ),
      ),
    );
  }

  Padding messageWhenUserShareUI(int i) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ReadMoreText(
          //
          arrHomePosts[i]['message'].toString(),
          //
          style: GoogleFonts.montserrat(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
          //
          trimLines: 3,
          colorClickableText: Colors.black,
          lessStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          trimMode: TrimMode.Line,
          trimCollapsedText: '...Show more',
          trimExpandedText: '...Show less',
          moreStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // UI => SIMPLE TEXT
  Padding simpleTextFeedUI(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        child: Column(
          children: [
            //
            //
            commonHeaderForAllCellTypesUI(context, i, ' shared some text'),
            //
            //
            HomeNewSimpleTextUIScreen(
                getSimpleTextDataWithIndex: arrHomePosts[i]),
            //
            //
            likeCommentShareUI(
              context,
              i,
              'no',
            ),
            //
          ],
        ),
      ),
    );
  }

  Container likeCommentShareUI(
    BuildContext context,
    serverData,
    hideShare,
  ) {
    return Container(
      // height: 40,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                //
                funcShowLikeClickWB(serverData);
                // print(serverData);
                //
              },
              child: Container(
                height: 40,
                // width: 40,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (arrHomePosts[serverData]['like_status'].toString() == 'no')
                        ? const Icon(
                            Icons.favorite_border,
                            size: 24.0,
                          )
                        : const Icon(
                            Icons.favorite,
                            size: 24.0,
                            color: Colors.pinkAccent,
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (arrHomePosts[serverData]['likesCount'].toString() ==
                        '0')
                      textWithRegularStyle(
                        'like',
                        Colors.grey[900],
                        14.0,
                      )
                    else if (arrHomePosts[serverData]['likesCount']
                            .toString() ==
                        '1')
                      textWithRegularStyle(
                        'like ( ${arrHomePosts[serverData]['likesCount']} )',
                        Colors.grey[900],
                        14.0,
                      )
                    else
                      textWithRegularStyle(
                        'likes ( ${arrHomePosts[serverData]['likesCount']} )',
                        Colors.grey[900],
                        14.0,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeNewCommentsScreen(
                      getUserIdForComment:
                          arrHomePosts[serverData]['postId'].toString(),
                    ),
                  ),
                );
                //
              },
              child: Container(
                height: 40,
                // width: 40,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.comment_outlined,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textWithRegularStyle(
                      'comment',
                      Colors.grey[900],
                      14.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          (hideShare == 'yes')
              ? const SizedBox(
                  width: 0,
                )
              : Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //
                      // share a post popup function
                      shareAPostPopUp(
                        context,
                        'Share this post ?',
                        serverData,
                      );
                      //
                    },
                    child: Container(
                      height: 40,
                      // width: 40,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.share,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          textWithRegularStyle(
                            'share',
                            Colors.grey[900],
                            14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

// COMMON HEADER => PROFILE IMAGE , NAME , TIME , DOTS
  Container commonHeaderForSharedCellTypesUI(
      BuildContext context, serverData, tagLine) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        children: [
          if (arrHomePosts[serverData]['share']['userImage'].toString() == '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icons/avatar.png',
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  30.0,
                ),
                child: Container(
                  height: 60,
                  width: 60,
                  color: Colors.amber,
                  child: Image.network(
                    //
                    arrHomePosts[serverData]['share']['userImage'].toString(),
                    fit: BoxFit.cover,
                    //
                  ),
                ),
              ),
            ),
          //
          Expanded(
            child: Container(
              // width: 40,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: arrHomePosts[serverData]['share']['userName']
                                .toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //
                          // tag line
                          TextSpan(
                            text: tagLine.toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),

                          //
                        ],
                      ),
                    ),
                  ),
                  //
                  // created time show
                  Align(
                    alignment: Alignment.centerLeft,
                    child: textWithRegularStyle(
                      timeago.format(
                        DateTime.parse(
                          arrHomePosts[serverData]['share']['created']
                              .toString(),
                        ),
                      ),
                      Colors.black,
                      14.0,
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),

          //
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                //
                // showLoadingUI(context, 'please wait...');

                //
              },
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // COMMON HEADER => PROFILE IMAGE , NAME , TIME , DOTS
  Container commonHeaderForAllCellTypesUI(
      BuildContext context, serverData, tagLine) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        children: [
          if (arrHomePosts[serverData]['SettingProfilePicture'].toString() ==
              '1') ...[
            if (arrHomePosts[serverData]['Userimage'].toString() == '')
              //
              onlyAvataProfilePictureUI(serverData)
            //
            else
              //
              profilePictureShowUI(serverData),
            //
          ] else if (arrHomePosts[serverData]['SettingProfilePicture']
                  .toString() ==
              '2') ...[
            // status 2 => we are friends
            //
            if (arrHomePosts[serverData]['Userimage'].toString() == '') ...[
              //
              onlyAvataProfilePictureUI(serverData)
            ]
            //
            else ...[
              (strGetUserId == arrHomePosts[serverData]['userId'].toString())
                  ? profilePictureShowUI(serverData)
                  : onlyAvataProfilePictureUI(serverData)
            ]

            //
          ] else if (arrHomePosts[serverData]['SettingProfilePicture']
                  .toString() ==
              '3') ...[
            // my DP is not visible to any one
            //
            if (arrHomePosts[serverData]['Userimage'].toString() == '')
              //
              onlyAvataProfilePictureUI(serverData)
            //
            else
              (strGetUserId == arrHomePosts[serverData]['userId'].toString())
                  ? profilePictureShowUI(serverData)
                  : onlyAvataProfilePictureUI(serverData)
            //
          ],

          //
          Expanded(
            child: Container(
              // width: 40,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                arrHomePosts[serverData]['fullName'].toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //
                          // tag line
                          TextSpan(
                            text: tagLine.toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),

                          //
                        ],
                      ),
                    ),
                  ),
                  //
                  // created time show
                  Align(
                    alignment: Alignment.centerLeft,
                    child: textWithRegularStyle(
                      timeago.format(
                        DateTime.parse(
                          arrHomePosts[serverData]['created'].toString(),
                        ),
                      ),
                      Colors.black,
                      14.0,
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),

          //

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                //
                // print(serverData);
                (arrHomePosts[serverData]['userId'].toString() == strGetUserId)
                    ? funcDeletePostPopup(serverData)
                    : funcReportPopup(serverData);
                //
              },
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector profilePictureShowUI(serverData) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('Image clicked');
        }
        //
        pushToUserProfilePage(
          context,
          arrHomePosts[serverData]['userId'].toString(),
        );
        //
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            30.0,
          ),
          child: Container(
            height: 60,
            width: 60,
            color: Colors.amber,
            child: Image.network(
              //
              arrHomePosts[serverData]['Userimage'].toString(),
              fit: BoxFit.cover,
              //
            ),
          ),
        ),
      ),
    );
  }

  //
  // UI = > AVATAR IMAGE SHOW
  GestureDetector onlyAvataProfilePictureUI(serverData) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('Image clicked');
        }
        //
        // funcPushToUserProfile(
        //   arrHomePosts[serverData]['userId'].toString(),
        // );

        pushToUserProfilePage(
          context,
          arrHomePosts[serverData]['userId'].toString(),
        );
        //
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/icons/avatar.png',
        ),
      ),
    );
  }

  funcDeletePostPopup(getServerData) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Delete post ?',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        //
                        // print('=================>' + serverData);
                        funcDeleteThisPost(getServerData);
                        //
                      },
                      child: textWithBoldStyle(
                        'Yes, delete',
                        Colors.redAccent,
                        18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  // API => report
  funcDeleteThisPost(getDataToLikeThatCell) {
    // print('yeah');
    // print(getDataToLikeThatCell);
    strReportPostPopupDismiss = '1';

    Navigator.pop(context);
    //
    showLoadingUI(context, 'deleting...');
    //
    if (kDebugMode) {
      print(arrHomePosts[getDataToLikeThatCell]['postId'].toString());
      print(getDataToLikeThatCell);
    }

    //
    funcDeleteThisPostWB(
        arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
        getDataToLikeThatCell);
    //

    // setState(() {});
  }

//
  funcDeleteThisPostWB(postId, indexIs) async {
    if (kDebugMode) {
      print('=====> POST : REPORT POST');
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
          'action': 'deletepost',
          'userId': strGetUserId.toString(),
          'postId': postId.toString(),
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

        arrHomePosts.removeAt(indexIs);
        setState(() {
          Navigator.pop(context);
        });
        //
      } else {
        if (kDebugMode) {}
        Navigator.pop(context);
      }
    } else {
      // return postList;
      Navigator.pop(context);
    }
  }

// upload feeds data to time line
  // deletePostFromServer(
  //   String postId,
  // ) async {
  //   //
  //   //
  //   if (kDebugMode) {
  //     print('=====> POST : DELETE POST');
  //   }

  //   final resposne = await http.post(
  //     Uri.parse(
  //       applicationBaseURL,
  //     ),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       <String, String>{
  //         'action': 'deletepost',
  //         'userId': strGetUserId.toString(),
  //         'postId': postId.toString(),
  //       },
  //     ),
  //   );

  //   // convert data to dict
  //   var getData = jsonDecode(resposne.body);
  //   if (kDebugMode) {
  //     print(getData);
  //   }

  //   if (resposne.statusCode == 200) {
  //     if (getData['status'].toString().toLowerCase() == 'success') {
  //       //
  //       funcSendUserIdToGetHomeData(
  //         strGetUserId.toString(),
  //         'yes',
  //         1,
  //       );
  //       //
  //     } else {
  //       if (kDebugMode) {
  //         print(
  //           '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
  //         );
  //       }
  //     }
  //   } else {
  //     // return postList;
  //   }
  // }

  funcReportPopup(getServerData) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Report this post ?',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        //
                        // print('=================>' + serverData);
                        funcReportThisPost(getServerData);
                        //
                      },
                      child: textWithBoldStyle(
                        'report',
                        Colors.redAccent,
                        18.0,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 40,
                // ),
                // Flexible(
                //   child: Container(
                //     height: 40,
                //     width: MediaQuery.of(context).size.width,
                //     color: Colors.transparent,
                //     child: Center(
                //       child: textWithBoldStyle(
                //         'report',
                //         Colors.black,
                //         18.0,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  // GET LOGIN USER FULL DATA
  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
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
                    strGetUserId = value[i].userId.toString(),
                    strLoginUserImage = value[i].image.toString(),
                    strGetUserDeviceToken = value[i].deviceToken.toString()

                    //
                  },
                // print('========= check device token =============== '),
                // print(strGetUserDeviceToken),

                /*if (strGetUserDeviceToken == '')
                  {
                    funcUpdateDeviceToken(),
                  }
                else
                  {*/
                funcSendUserIdToGetHomeData(
                  strGetUserId.toString(),
                  'no',
                  pageControl,
                ),
                // }
                // show loading indicator

                //
              });
        }
      },
    );
    //
  }

  // upload feeds data to time line
  funcUpdateDeviceToken() async {
    //
    // showLoadingUI(context, 'uploading...');
    //
    if (kDebugMode) {
      print('=====> POST : UPDATE DEVICE TOKEN ');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'editprofile',
          'userId': strGetUserId.toString(),
          'device': 'iOS',
          'deviceToken': prefs.getString('deviceToken').toString(),
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
        // delete old local DB
        handler.deletePlanet(1);
        //
        List<Planets> loginUserDataForLocalDB = [];
        for (int i = 0; i < 1; i++) {
          Planets one = Planets(
            id: 1,
            userId: data['data']['userId'].toString(),
            fullName: data['data']['fullName'].toString(),
            lastName: data['data']['lastName'].toString(),
            middleName: data['data']['middleName'].toString(),
            email: data['data']['email'].toString(),
            gender: data['data']['gender'].toString(),
            contactNumber: data['data']['contactNumber'].toString(),
            role: data['data']['role'].toString(),
            dob: data['data']['dob'].toString(),
            address: data['data']['address'].toString(),
            zipCode: data['data']['zipCode'].toString(),
            city: data['data']['city'].toString(),
            state: data['data']['state'].toString(),
            status: data['data']['status'].toString(),
            image: data['data']['image'].toString(),
            device: data['data']['device'].toString(),
            deviceToken: data['data']['deviceToken'].toString(),
            socialId: data['data']['socialId'].toString(),
            socialType: data['data']['socialType'].toString(),
            latitude: data['data']['latitude'].toString(),
            longitude: data['data']['longitude'].toString(),
            firebaseId: data['data']['firebaseId'].toString(),
            username: data['data']['username'].toString(),
          );

          loginUserDataForLocalDB.add(one);
        }
        //
        // print('object 3333');
        if (kDebugMode) {
          print(loginUserDataForLocalDB);
        }
        handler.insertPlanets(loginUserDataForLocalDB);
        //
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'no',
          pageControl,
        );
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

  //
  // like click method
  funcShowLikeClickWB(getDataToLikeThatCell) {
    if (kDebugMode) {
      print(arrHomePosts[getDataToLikeThatCell]);
      print(getDataToLikeThatCell);
      print(arrHomePosts[getDataToLikeThatCell]['like_status']);
    }
    //
    // show please wait loader
    // strLikepopupDismiss = '1';
    showLoadingUI(context, 'please wait...');

    Map<String, dynamic> data;
    if (arrHomePosts[getDataToLikeThatCell]['like_status'].toString() == 'no') {
      //
      data = {
        'postId': arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
        'userId': arrHomePosts[getDataToLikeThatCell]['userId'].toString(),
        'message': arrHomePosts[getDataToLikeThatCell]['message'].toString(),
        'postType': arrHomePosts[getDataToLikeThatCell]['postType'].toString(),
        'created': arrHomePosts[getDataToLikeThatCell]['created'].toString(),
        'timeZone': arrHomePosts[getDataToLikeThatCell]['timeZone'].toString(),
        'fullName': arrHomePosts[getDataToLikeThatCell]['fullName'].toString(),
        'lastName': arrHomePosts[getDataToLikeThatCell]['lastName'].toString(),
        'email': arrHomePosts[getDataToLikeThatCell]['email'].toString(),
        'contactNumber':
            arrHomePosts[getDataToLikeThatCell]['contactNumber'].toString(),
        'status': arrHomePosts[getDataToLikeThatCell]['status'].toString(),
        'SettingProfile':
            arrHomePosts[getDataToLikeThatCell]['SettingProfile'].toString(),
        'SettingProfilePicture': arrHomePosts[getDataToLikeThatCell]
                ['SettingProfilePicture']
            .toString(),
        'Userimage':
            arrHomePosts[getDataToLikeThatCell]['Userimage'].toString(),
        'postImage': arrHomePosts[getDataToLikeThatCell]['postImage'],
        'share': arrHomePosts[getDataToLikeThatCell]['share'],
        'likesCount': arrHomePosts[getDataToLikeThatCell]['likesCount'] + 1,
        'youliked': arrHomePosts[getDataToLikeThatCell]['youliked'].toString(),
        'friendStatus':
            arrHomePosts[getDataToLikeThatCell]['friendStatus'].toString(),
        'like_status': 'yes'
      };

      //
      // insert custom data with like status yes
      arrHomePosts.removeAt(getDataToLikeThatCell);
      arrHomePosts.insert(getDataToLikeThatCell, data);
      //
    } else {
      //
      data = {
        'postId': arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
        'userId': arrHomePosts[getDataToLikeThatCell]['userId'].toString(),
        'message': arrHomePosts[getDataToLikeThatCell]['message'].toString(),
        'postType': arrHomePosts[getDataToLikeThatCell]['postType'].toString(),
        'created': arrHomePosts[getDataToLikeThatCell]['created'].toString(),
        'timeZone': arrHomePosts[getDataToLikeThatCell]['timeZone'].toString(),
        'fullName': arrHomePosts[getDataToLikeThatCell]['fullName'].toString(),
        'lastName': arrHomePosts[getDataToLikeThatCell]['lastName'].toString(),
        'email': arrHomePosts[getDataToLikeThatCell]['email'].toString(),
        'contactNumber':
            arrHomePosts[getDataToLikeThatCell]['contactNumber'].toString(),
        'status': arrHomePosts[getDataToLikeThatCell]['status'].toString(),
        'SettingProfile':
            arrHomePosts[getDataToLikeThatCell]['SettingProfile'].toString(),
        'SettingProfilePicture': arrHomePosts[getDataToLikeThatCell]
                ['SettingProfilePicture']
            .toString(),
        'Userimage':
            arrHomePosts[getDataToLikeThatCell]['Userimage'].toString(),
        'postImage': arrHomePosts[getDataToLikeThatCell]['postImage'],
        'share': arrHomePosts[getDataToLikeThatCell]['share'],
        'likesCount': arrHomePosts[getDataToLikeThatCell]['likesCount'] - 1,
        'youliked': arrHomePosts[getDataToLikeThatCell]['youliked'].toString(),
        'friendStatus':
            arrHomePosts[getDataToLikeThatCell]['friendStatus'].toString(),
        'like_status': 'no'
      };
      //

      //
      // insert custom data with like status yes
      arrHomePosts.removeAt(getDataToLikeThatCell);
      arrHomePosts.insert(getDataToLikeThatCell, data);
      //
    }
    // setState(() {});

    /*print('=====================================');
    print('=====================================');
    print('=====================================');
    print('=====================================');
    print(arrHomePosts[getDataToLikeThatCell]['like_status'].toString());
    print('=====================================');
    print('=====================================');
    print('=====================================');
    print('=====================================');*/

    (arrHomePosts[getDataToLikeThatCell]['like_status'].toString() == 'no')
        ? homeLikeUnlikeApiCall
            .homeLikeUnlikeWB(
              strGetUserId.toString(),
              arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
              '0',
            )
            .then((value) => {
                  // funcSendUserIdToGetHomeData(
                  //   strGetUserId.toString(),
                  //   'no',
                  //   pageControl,
                  // ),
                  setState(() {
                    Navigator.pop(context);
                  }),
                })
        : homeLikeUnlikeApiCall
            .homeLikeUnlikeWB(
              strGetUserId.toString(),
              arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
              '1',
            )
            .then((value) => {
                  // funcSendUserIdToGetHomeData(
                  //   strGetUserId.toString(),
                  //   'no',
                  //   pageControl,
                  // ),
                  setState(() {
                    Navigator.pop(context);
                  }),
                });
  }

  //
  // API => report
  funcReportThisPost(getDataToLikeThatCell) {
    // print('yeah');
    // print(getDataToLikeThatCell);
    strReportPostPopupDismiss = '1';

    Navigator.pop(context);
    //
    showLoadingUI(context, 'reporting');
    //
    if (kDebugMode) {
      print(arrHomePosts[getDataToLikeThatCell]['postId'].toString());
      print(getDataToLikeThatCell);
    }

    //
    funcReportThisPostWB(
        arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
        getDataToLikeThatCell);
    //

    // setState(() {});
  }

  //
  funcReportThisPostWB(postIdIs, indexIs) async {
    if (kDebugMode) {
      print('=====> POST : REPORT POST');
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
          'action': 'blockpost',
          'userId': strGetUserId.toString(),
          'postId': postIdIs.toString(),
          'status': '1'.toString(),
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

        arrHomePosts.removeAt(indexIs);
        setState(() {
          Navigator.pop(context);
        });
        //
      } else {
        if (kDebugMode) {}
        Navigator.pop(context);
      }
    } else {
      // return postList;
      Navigator.pop(context);
    }
  }

  //
  funcShowUserHeaderTileWhileSharePost(indexx, tagLine) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        children: [
          if (arrHomePosts[indexx]['Userimage'].toString() == '')
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Image clicked');
                }
                //
                pushToUserProfilePage(
                  context,
                  arrHomePosts[indexx]['userId'].toString(),
                );
                //
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/icons/avatar.png',
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Image clicked');
                }
                //
                pushToUserProfilePage(
                  context,
                  arrHomePosts[indexx]['userId'].toString(),
                );
                //
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.amber,
                    child: Image.network(
                      //
                      arrHomePosts[indexx]['Userimage'].toString(),
                      fit: BoxFit.cover,
                      //
                    ),
                  ),
                ),
              ),
            ),
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // width: 40,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: arrHomePosts[indexx]['fullName'].toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                            // tag line
                            TextSpan(
                              text: tagLine.toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 14.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),

                            //
                          ],
                        ),
                      ),
                    ),
                    //
                    // created time show
                    Align(
                      alignment: Alignment.centerLeft,
                      child: textWithRegularStyle(
                        timeago.format(
                          DateTime.parse(
                            arrHomePosts[indexx]['created'].toString(),
                          ),
                        ),
                        Colors.black,
                        14.0,
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  // share a post popup
  //
  void shareAPostPopUp(
    BuildContext context,
    String message,
    indexNumber,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      message,
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 20,
                ),
                //
                TextFormField(
                  controller: contWriteSomething,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    // border: Border(),
                    // labelText: '',
                    hintText: 'write something',
                  ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value.length);
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 10,
                ),
                if (arrHomePosts[indexNumber]['postType'].toString() ==
                    'Text') ...[
                  const SizedBox(
                    height: 10,
                  ),
                  funcShowUserHeaderTileWhileSharePost(
                    indexNumber,
                    ' shared some text',
                  ),
                  //
                  const SizedBox(
                    height: 20,
                  ),
                  //
                  // data
                  Align(
                    alignment: Alignment.centerLeft,
                    child: textWithBoldStyle(
                      //
                      arrHomePosts[indexNumber]['message'].toString(),
                      //
                      Colors.black,
                      16.0,
                    ),
                  ),
                  //
                  // const SizedBox(
                  //   height: 10,
                  // ),
                ] else if (arrHomePosts[indexNumber]['postType'].toString() ==
                    'Image') ...[
                  const SizedBox(
                    height: 10,
                  ),
                  funcShowUserHeaderTileWhileSharePost(
                    indexNumber,
                    ' shared some images',
                  ),
                  //
                  //
                  // show images on feeds
                  // HomeNewImageScreen(
                  // getDataForImageWithIndex: arrHomePosts[indexNumber]),

                  // for images

                  Container(
                    height: 260,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: PageView.builder(
                      onPageChanged: (int value) {
                        if (kDebugMode) {
                          // print(value);
                        }
                        //

                        // setState(() {});
                        strImageCount = value;
                      },
                      itemCount: arrHomePosts[indexNumber]['postImage'].length,
                      pageSnapping: true,
                      itemBuilder: (context, pagePosition) {
                        //
                        currentIndex = pagePosition + 1;
                        if (kDebugMode) {
                          print(currentIndex);
                        }
                        //
                        return Stack(
                          children: [
                            //
                            GestureDetector(
                              onTap: () {
                                //
                                arrScrollMultipleImages.clear();
                                //
                                // funcOpenImage(
                                // pagePosition, arrHomePosts[indexNumber]);
                                //
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 240,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    // color: i == currentIndex ? Colors.white : Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                // child:
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    24.0,
                                  ),
                                  child: Image.network(
                                    //
                                    arrHomePosts[indexNumber]['postImage']
                                        [pagePosition]['name'],
                                    //
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //
                            // Text(currentIndex.toString()),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  right: 20.0,
                                ),
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                ),
                                child: Center(
                                  child: textWithRegularStyle(
                                    '$currentIndex / ${arrHomePosts[indexNumber]['postImage'].length}',
                                    Colors.white,
                                    14.0,
                                  ),
                                ),
                              ),
                            ),
                            //
                          ],
                        );
                      },
                    ),
                  ),

                  //
                ] else if (arrHomePosts[indexNumber]['postType'].toString() ==
                    'Video') ...[
                  const SizedBox(
                    height: 10,
                  ),
                  funcShowUserHeaderTileWhileSharePost(
                    indexNumber,
                    ' shared some video',
                  ),
                  //
                  // show video on feeds
                  // HomeNewVideoUIScreen(
                  // getDataFroVideoUIWithIndex: arrHomePosts[indexNumber],
                  // ),
                  Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: FutureBuilder(
                      future: generateThumbnail(
                        arrHomePosts[indexNumber]['postImage'][0]['name']
                            .toString(),
                      ),
                      builder: (context, snapshot) {
                        // f (snapshot.connectionState ==
                        // ConnectionState.done) {
                        return Container(
                          // margin: const EdgeInsets.all(10.0),

                          width: MediaQuery.of(context).size.width,
                          height: 240,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              //
                              Container(
                                // margin: const EdgeInsets.all(10.0),
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                child: (snapshot.data == null)
                                    ? Image.asset(
                                        'assets/images/1024_no_bg.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(
                                          snapshot.data.toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              //
                              (strPlayPause == '0')
                                  ? Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          //
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeNewPlayVideoScreen(
                                                getURL:
                                                    arrHomePosts[indexNumber]
                                                                ['postImage'][0]
                                                            ['name']
                                                        .toString(),
                                              ),
                                            ),
                                          );
                                          //
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          width: 48.0,
                                          height: 48.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              24.0,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    )
                            ],
                            // child:
                          ),
                        );
                      },
                    ),
                  ),
                  //
                ] else if (arrHomePosts[indexNumber]['postType'].toString() ==
                    'Map') ...[
                  const SizedBox(
                    height: 10,
                  ),
                  funcShowUserHeaderTileWhileSharePost(
                    indexNumber,
                    ' share location',
                  ),
                  //
                  const SizedBox(
                    height: 20,
                  ),
                  //

                  if (arrHomePosts[indexNumber]['share'] == null) ...[
                    //
                    HomeNewMapScreen(getData: arrHomePosts[indexNumber]),

                    //
                  ] else ...[
                    //
                    //
                    if (arrHomePosts[indexNumber]['share']['message']
                            .split(',')[2] ==
                        '')
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ReadMoreText(
                            //
                            arrHomePosts[indexNumber]['message'].split(',')[2],
                            //
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                            //
                            trimLines: 3,
                            colorClickableText: Colors.black,
                            lessStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Show more',
                            trimExpandedText: '...Show less',
                            moreStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // HomeNewSharedMapUIScreen(
                    //   getDataSharedMapUIWithIndex: arrHomePosts[indexNumber],
                    // ),
                  ]

                  //
                ]
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //
                  //
                  funcCheckWhichPostType(
                      arrHomePosts[indexNumber]['postId'].toString(),
                      arrHomePosts[indexNumber]['postType'].toString(),
                      indexNumber);
                  //
                },
                child: textWithBoldStyle(
                  'Upload',
                  Colors.green,
                  16.0,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: textWithBoldStyle(
                  'Dismiss',
                  Colors.black,
                  16.0,
                ),
              ),
            ),
            //
          ],
        );
      },
    );
  }

  //
  // this function generate thumbnail
  generateThumbnail(videoURL) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 1000,
      maxWidth: 1000,
      timeMs: 1,
      quality: 75,
    );
    return uint8list;
  }

  //
  //
  funcCheckWhichPostType(getShareId, getPostType, indexNumber) {
    if (getPostType == 'Text') {
      Navigator.pop(context);
      strReCreateHomePage = '1';
      showLoadingUI(context, 'uploading');
      funcShareDataWB(getShareId, getPostType);
      // print(contWriteSomething.text);
    } else if (getPostType == 'Map') {
      Navigator.pop(context);
      strReCreateHomePage = '1';
      //
      strSharedLat = '${arrHomePosts[indexNumber]['message'].split(',')[0]}';
      strSharedLong = '${arrHomePosts[indexNumber]['message'].split(',')[1]}';
      //
      showLoadingUI(context, 'sharing! please wait...');

      funcShareDataWB(getShareId, 'Map');
    } else if (getPostType == 'Image') {
      Navigator.pop(context);
      strReCreateHomePage = '1';
      showLoadingUI(context, 'uploading');
      funcShareDataWB(getShareId, 'Image');
      // print(contWriteSomething.text);
    } else if (getPostType == 'Video') {
      Navigator.pop(context);
      strReCreateHomePage = '1';
      showLoadingUI(context, 'uploading');
      funcShareDataWB(getShareId, 'Video');
      // print(contWriteSomething.text);
    }
  }

  //
  // WB = > SHARE POST
  ///action:posthome
  // upload feeds data to time line
  funcShareDataWB(
    String strShareId,
    String postType,
  ) async {
    //

    //
    if (kDebugMode) {
      print('=====> POST : SHARE DATA');
    }

    var strMessageIs = '';

    if (postType == 'Text') {
      strMessageIs = contWriteSomething.text;
    } else if (postType == 'Image') {
      strMessageIs = contWriteSomething.text;
    } else if (postType == 'Video') {
      strMessageIs = contWriteSomething.text;
    } else {
      strMessageIs = '$strSharedLat,$strSharedLong,${contWriteSomething.text}';
    }

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.now(),
    );

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'posthome',
          'userId': strGetUserId.toString(),
          'message': strMessageIs.toString(),
          'postType': postType.toString(),
          'shareId': strShareId.toString(),
          'created': formattedDate
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
        pageControl = 1;
        //
        contWriteSomething.text = '';
        //
        arrHomePosts.clear();
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'no',
          1,
        );
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

  //
  //
  //
  void openUploadOptions(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Please select an option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              openAlertFroSimpleText(context);
              //
            },
            child: textWithRegularStyle(
              'Text',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //
              selectImages();
              //
            },
            child: textWithRegularStyle(
              'Open Gallery',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              selectVideo();
              //
            },
            child: textWithRegularStyle(
              'Open Video Gallery',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //
              contWriteSomething.text = '';
              //
              funcGetUserLatAndLong();
              //
            },
            child: textWithRegularStyle(
              'Share your location',
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

  //
  //
  // select multiple images
  void selectVideo() async {
    //
    imageFileList!.clear();
    //
    PickedFile? pickedFile = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      // maxWidth: 1800,
      // maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        if (kDebugMode) {
          print('object 1');
        }
        // when user select photo from gallery
        // strPostType = '3';
        // hide send button for text
        // strTextCount = '0';
        //

        imageFile = File(pickedFile.path);
        //
        if (kDebugMode) {
          print(imageFile);
        }
        //
        // as
        _controller = VideoPlayerController.file(imageFile!);
        _initializeVideoPlayerFuture = _controller!.initialize();
        openAlertAfterSelectVideoFromGallery(context);
      });
    }
  }

  funcGetUserLatAndLong() async {
    var myLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    // if (kDebugMode) {
    //   print(myLocation.latitude);
    // }
    // if (kDebugMode) {
    //   print(myLocation.longitude);
    // }
    //
    strUserLat = myLocation.latitude;
    strUserLong = myLocation.longitude;

    //
    // print(strUserLat);
    // print(strUserLong);
    openAlertWhenUserShareLocation(
      context,
    );
  }

//
  // share a post popup
  //
  void openAlertWhenUserShareLocation(
    BuildContext context,

    // String message,
    // indexNumber,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Share you location',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 20,
                ),
                //
                TextFormField(
                  controller: contWriteSomething,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    // border: Border(),
                    // labelText: '',
                    hintText: 'write something',
                  ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value.length);
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 10,
                ),
                //
                Column(
                  children: [
                    //

                    //
                    // show map on feeds
                    HomeNewMapScreen(
                      getData: {
                        'message':
                            '${strUserLat.toString()},${strUserLong.toString()},${contWriteSomething.text}',
                      },
                    ),

                    //
                  ],
                ),
                //
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //
                  // uploadMultipleImagesOnServer('Video');

                  funcUploadDataWithOnlyMap();
                  //
                },
                child: textWithBoldStyle(
                  'Upload',
                  Colors.green,
                  16.0,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: textWithBoldStyle(
                  'Dismiss',
                  Colors.black,
                  16.0,
                ),
              ),
            ),
            //
          ],
        );
      },
    );
  }

  //
  void _onMapCreated(GoogleMapController controller) {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        double.parse('28.5678'),
        double.parse('78.159898'),
      ),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: '',
        snippet: '',
      ),
    );

    if (mounted == true) {
      setState(() {
        markers[MarkerId('place_name')] = marker;
      });
    }
  }

  //
  // share a post popup
  //
  void openAlertFroSimpleText(
    BuildContext context,
    // String message,
    // indexNumber,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Text',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 20,
                ),
                //
                TextFormField(
                  controller: contWriteSomething,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    // border: Border(),
                    // labelText: '',
                    hintText: 'write something',
                  ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value.length);
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 10,
                ),

                //
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //
                  // uploadMultipleImagesOnServer('Video');
                  funcUploadDataWithOnlyText();
                  //
                },
                child: textWithBoldStyle(
                  'Upload',
                  Colors.green,
                  16.0,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: textWithBoldStyle(
                  'Dismiss',
                  Colors.black,
                  16.0,
                ),
              ),
            ),
            //
          ],
        );
      },
    );
  }

  //
  // show video
  //
  // share a post popup
  //
  void openAlertAfterSelectVideoFromGallery(
    BuildContext context,
    // String message,
    // indexNumber,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Upload Video',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 20,
                ),
                //
                TextFormField(
                  controller: contWriteSomething,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    // border: Border(),
                    // labelText: '',
                    hintText: 'write something',
                  ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value.length);
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 10,
                ),
                // funcShowUserHeaderTileWhileSharePost(
                //   0,
                //   ' shared some video',
                // ),
                //
                // show video on feeds
                // HomeNewVideoUIScreen(
                // getDataFroVideoUIWithIndex: arrHomePosts[indexNumber],
                // ),
                Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    // generateThumbnail(
                    //   arrHomePosts[0]['postImage'][0]['name'].toString(),
                    // ),
                    builder: (context, snapshot) {
                      // f (snapshot.connectionState ==
                      // ConnectionState.done) {
                      return Container(
                        // margin: const EdgeInsets.all(10.0),

                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            //
                            Container(
                              // margin: const EdgeInsets.all(10.0),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child: VideoPlayer(
                                _controller!,
                              ),
                              /*(snapshot.data == null)
                                  ? Image.asset(
                                      'assets/images/1024_no_bg.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(
                                        snapshot.data.toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),*/
                            ),
                            //
                            (strPlayPause == '0')
                                ? Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        //
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         HomeNewPlayVideoScreen(
                                        //       getURL: _controller.toString(),
                                        //     ),
                                        //   ),
                                        // );
                                        //
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10.0),
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            24.0,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  )
                          ],
                          // child:
                        ),
                      );
                    },
                  ),
                ),

                //
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //
                  uploadMultipleImagesOnServer('Video');
                  //
                },
                child: textWithBoldStyle(
                  'Upload',
                  Colors.green,
                  16.0,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: textWithBoldStyle(
                  'Dismiss',
                  Colors.black,
                  16.0,
                ),
              ),
            ),
            //
          ],
        );
      },
    );
  }

  //
  // share a post popup
  //
  void openAlertWhenUserSelectImagesFromGallery(
    BuildContext context,
    // String message,
    // indexNumber,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Flexible(
                  child: SingleChildScrollView(
                    child: textWithRegularStyle(
                      //
                      'Upload photos',
                      //
                      Colors.black,
                      14.0,
                    ),
                  ),
                ),
                //
                const SizedBox(
                  height: 20,
                ),
                //
                TextFormField(
                  controller: contWriteSomething,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    // border: Border(),
                    // labelText: '',
                    hintText: 'write something',
                  ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print(value.length);
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
                ),
                // funcShowUserHeaderTileWhileSharePost(
                //   indexNumber,
                //   ' shared some images',
                // ),
                //
                //
                // show images on feeds
                /*HomeNewImageScreen(
                      getDataForImageWithIndex: arrHomePosts[indexNumber]),*/
                //

                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //     'assets/images/1.jpg',
                    //   ),
                    // ),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: imageFileList!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: strGridCount,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList![index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  /*child: Image.file(
                  fit: BoxFit.contain,
                  imageFile!,
                  // height: 150.0,
                  // width: 100.0,
                ),*/
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //
                  //
                  uploadMultipleImagesOnServer('Image');
                  //
                },
                child: textWithBoldStyle(
                  'Upload',
                  Colors.green,
                  16.0,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: textWithBoldStyle(
                  'Dismiss',
                  Colors.black,
                  16.0,
                ),
              ),
            ),
            //
          ],
        );
      },
    );
  }

  //
  // WB => UPLOAD VIDEO ON SERVER
  //
  uploadMultipleImagesOnServer(
    String postType,
  ) async {
    if (postType == 'Image') {
      if (kDebugMode) {
        print('USER WANTS TO UPLOAD PHOTOS');
      }
      //
      showLoadingUI(context, 'uploading images...');
      //
    } else {
      if (kDebugMode) {
        print('USER WANTS TO UPLOAD VIDEO');
      }
      //
      showLoadingUI(context, 'uploading video...');
      //
    }

    //

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.now(),
    );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    request.fields['action'] = 'posthome';
    request.fields['userId'] = strGetUserId.toString();
    request.fields['message'] = contWriteSomething.text.toString();
    request.fields['postType'] = postType.toString();
    request.fields['created'] = formattedDate.toString();

    if (postType == 'Image') {
      for (int i = 0; i < imageFileList!.length; i++) {
        // print(i);
        request.files.add(
          http.MultipartFile(
            'multiImage.'
            '$i',
            File(imageFileList![i].path).readAsBytes().asStream(),
            File(imageFileList![i].path).lengthSync(),
            filename: (imageFileList![i].path.split("/").last),
            // contentType: MediaType('multiImage', 'png'),
          ),
        );
        // newList.add(request as http.MultipartFile);
      }
    } else {
      request.files.add(
          await http.MultipartFile.fromPath('multiImage_0', imageFile!.path));
    }
    // 1

    /**/

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    if (kDebugMode) {
      print(responsedData);
    }

    if (responsedData['status'].toString() == 'Success'.toLowerCase()) {
      //
      strUploadVideoLoader = '1';
      arrHomePosts.clear();
      //
      funcSendUserIdToGetHomeData(
        strGetUserId.toString(),
        'no',
        1,
      );
      //
    }
  }

// upload feeds data to time line
  funcUploadDataWithOnlyMap() async {
    //
    showLoadingUI(context, 'uploading...');
    //
    if (kDebugMode) {
      print('=====> POST : UPLOAD ONLY MAP ');
    }

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.now(),
    );

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'posthome',
          'userId': strGetUserId.toString(),
          'message':
              '${strUserLat.toString()},${strUserLong.toString()},${contWriteSomething.text.toString()}',
          'postType': 'Map',
          'created': formattedDate
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
        //
        strUploadVideoLoader = '1';
        arrHomePosts.clear();
        contWriteSomething.text = '';
        //
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'no',
          1,
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

  // upload feeds data to time line
  funcUploadDataWithOnlyText() async {
    //
    showLoadingUI(context, 'uploading...');
    //
    if (kDebugMode) {
      print('=====> POST : UPLOAD ONLY TEXT ');
    }

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.now(),
    );

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'posthome',
          'userId': strGetUserId.toString(),
          'message': contWriteSomething.text.toString(),
          'postType': 'Text',
          'created': formattedDate
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
        //
        strUploadVideoLoader = '1';
        arrHomePosts.clear();
        contWriteSomething.text = '';
        //
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'no',
          1,
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

  // select multiple images
  void selectImages() async {
    //
    print('dishant rajput 1');
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
      print('dishant rajput 2');
      print("Image List Length: =====> ${imageFileList!.last}");
      print("Image List Length: =====> ${imageFileList!.length}");
    }

    setState(() {
      // when user select photo from gallery
      // strPostType = '2';
      // hide send button for text
      // strTextCount = '0';
      //
      if (imageFileList!.length == 1) {
        strGridCount = 1;
      } else if (imageFileList!.length == 2) {
        strGridCount = 2;
      } else if (imageFileList!.length == 3) {
        strGridCount = 2;
      } else if (imageFileList!.length == 4) {
        strGridCount = 2;
      } else {
        strGridCount = 3;
      }
      //
    });

    // uploadImageToServer();
    openAlertWhenUserSelectImagesFromGallery(context);
  }

  //
  //
  funcOpenImage(pagePosition, i) {
    for (int j = 0; j < arrHomePosts[i]['postImage'].length; j++) {
      arrScrollMultipleImages.add(arrHomePosts[i]['postImage'][j]['name']);
    }

    CustomImageProvider customImageProvider = CustomImageProvider(
        //
        imageUrls: arrScrollMultipleImages.toList(),

        //
        initialIndex: pagePosition);
    showImageViewerPager(context, customImageProvider, doubleTapZoomable: true,
        onPageChanged: (page) {
      // print("Page changed to $page");
    }, onViewerDismissed: (page) {
      // print("Dismissed while on page $page");
    });
  }

  //
  //
  Future<void> pushToUserProfilePage(
    BuildContext context,
    postUserId,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileNewScreen(
          strUserId: postUserId.toString(),
          strGetPostUserId: postUserId.toString(),
        ),
      ),
    );

    if (kDebugMode) {
      print('result =====> ' + result);
    }

    if (!mounted) return;

    // team_task_loader = '0';

    setState(() {
      arrHomePosts.clear();
    });

    //
    showLoadingUI(context, 'please wait...');
    //
    strLoadingWhenUserCameBackToDashboard = '1';
    //

    funcSendUserIdToGetHomeData(
      strGetUserId.toString(),
      'no',
      pageControl,
    );
    //
  }
}
