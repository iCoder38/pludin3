// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

// import 'package:easy_image_viewer/easy_image_viewer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
// import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
// import 'package:pludin/classes/controllers/chat/chat.dart';
// import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/home/home_like_modal/home_like_modal.dart';
// import 'package:pludin/classes/controllers/profile/my_profile_feeds/my_profile_feeds.dart';
import 'package:pludin/classes/controllers/profile/my_profile_modal/my_profile_modal.dart';
import 'package:pludin/classes/controllers/profile/profile_gallery/photo_gallery_modal/photo_gallery_modal.dart';
// import 'package:pludin/classes/controllers/profile/profile_gallery/profile_gallery.dart';
// import 'package:pludin/classes/controllers/profile/profile_videos/profile_videos.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:http/http.dart' as http;
import 'package:pludin/classes/user_profile_new/user_new_profile_images/user_new_profile_image.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:readmore/readmore.dart';

import '../controllers/chat/chat.dart';
import '../controllers/database/database_helper.dart';

import 'package:http_parser/http_parser.dart';

import '../controllers/home/home_modal/home_modal.dart';
// import '../controllers/profile/profile_gallery/profile_gallery.dart';
import '../controllers/profile/profile_gallery/profile_gallery.dart';
import '../home_new/home_new_comments/home_new_comments.dart';
import '../home_new/home_new_image/home_new_image.dart';
import '../home_new/home_new_map/home_new_map.dart';
import '../home_new/home_new_play_video/home_new_play_video.dart';
import '../home_new/home_new_shared_image/home_new_shared_image.dart';
import '../home_new/home_new_shared_map/home_new_shared_map_ui.dart';
import '../home_new/home_new_shared_text/home_new_shared_text.dart';
import '../home_new/home_new_shared_video/home_new_shared_video_ui.dart';
import '../home_new/home_new_simple_text_UI/home_new_simple_text_ui.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../home_new/home_new_video_ui/home_new_video_ui.dart';

// import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class UserProfileNewScreen extends StatefulWidget {
  const UserProfileNewScreen(
      {super.key, required this.strUserId, required this.strGetPostUserId});

  final String strUserId;
  final String strGetPostUserId;

  @override
  State<UserProfileNewScreen> createState() => _UserProfileNewScreenState();
}

class _UserProfileNewScreenState extends State<UserProfileNewScreen> {
  //
  final homeLikeUnlikeApiCall = HomeLikeModal();
  //
  var showUI = '0';
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
  //
  // home api modal
  final homeApiCall = HomeModal();
  //
  //
  var newPageControl = 1;
  //
  // save all feeds in array list
  var arrHomePosts = [];
  var strLikepopupDismiss = '0';
  var strReportPostPopupDismiss = '0';
  var strHideWhenPaginationDone = '0';
  //
  var strUserSelectWhichProfileFeeds = '0';
  var strUserSelectWhichProfileProfile = '0';
  var strUserSelectWhichProfileVideo = '0';

  //
  var strShowHideUI = '0';
  var strWhoCanViewYourPost = '0';
  var strHideShowThreeButtons = '0';
  //
  @override
  void initState() {
    super.initState();
    //
    //showLoadingUI(context, 'please wait...');

    //
    handler = DataBase();

    //
    funcGetLocalDBdata();

    //
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
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
                    if (kDebugMode)
                      {
                        // print('=================================='),
                        // print('=================================='),
                        // print(widget.strUserId),
                        // print(widget.strGetPostUserId),
                        // print(strLoginUserId),
                        // print('=================================='),
                        // print('=================================='),
                      }

                    //
                  },
                //
                funcGetFriendsProfileData(),
                //
              });
        }
      },
    );
    //
  }

  funcGetFriendsProfileData() {
    // showLoadingUI(context, 'please wait...');
    //
    userProfileApiCall
        .userProfileWB(
          widget.strUserId.toString(),
          strLoginUserId.toString(),
        )
        .then((value) => {
              // print('me call'),
//

              // funcSendUserIdToGetHomeData(
              //   strLoginUserId.toString(),
              //   pageControl,
              // ),

              fetchedAllData = value['data'],

              //
              getOtherUserProfileData(newPageControl),
              //
              // print(strLoginUserId),
              // print(fetchedAllData['userId'].toString()),
              //
              // //

              // funcSendUserIdToGetHomeData(
              //   strLoginUserId.toString(),
              //   'strBack',
              //   '1',
              // ),
            });
  }

  //
  //
  // upload feeds data to time line
  getOtherUserProfileData(int pageNumber) async {
    //
    if (kDebugMode) {
      print('=====> POST : OTHER USER PROFILE DATA 2 ');
      print(showUI);
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
          'action': 'home',
          'userId': strLoginUserId.toString(),
          'otherId': widget.strGetPostUserId.toString(),
          'type': 'Other',
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
        // if (showUI == '0') {
        //   Navigator.pop(context);
        // }
        //

        var arr = [];
        for (Map i in getData['data']) {
          arr.add(i);
        }

        funcCreateMyOwnCustomResponse(arr);
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

  // GET HOME FEEDS DATA => WB
  funcSendUserIdToGetHomeData(
    strLoginUserId,
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
      // print('=========== RESPONSE =============');
      // print(getResponseFromServer);
      // print(getResponseFromServer.length);
      // print('==================================');
      // print('==================================');
    }
    //
    Map<String, dynamic> data;
    // print(arrHomePosts.length);

    if (kDebugMode) {
      print('======================');
      print('======================');
      print('======================');
      print('======================');
      print(fetchedAllData);
      print(
          'postPrivacySetting =====> ${fetchedAllData["PostPrivacy_setting"]}');
      print('Profile_setting =====> ${fetchedAllData["Profile_setting"]}');
      print('Friends =============> ${fetchedAllData["friendStatus"]}');
      print('======================');
      print('======================');
      print('======================');
      print('======================');
    }

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
      //
    }

    //
    // if (kDebugMode) {
    //   print('show hide user id =====> $arrHomePosts');
    // }

    funcSetSettings();
  }

  funcSetSettings() {
    if (kDebugMode) {
      print(fetchedAllData);
    }
    //
    //
    //if (fetchedAllData['friendStatus'].toString() == '2') {
    /*if (fetchedAllData['Profile_setting'].toString() == '2') {
      // friends
      if (fetchedAllData['friendStatus'].toString() == '2') {
        // yes they both are friends
        //
        // do not clear the array data
        //
      } else if (fetchedAllData['friendStatus'].toString() == '1') {
        // request has been sent or received
        //
        // do not clear the array data
        //
        // hide three button UI
        strHideShowThreeButtons = '1';
        //
      } else if (fetchedAllData['friendStatus'].toString() == '0') {
        // request has been sent or received
        //
        // do not clear the array data
        //
        // hide three button UI
        strHideShowThreeButtons = '1';
      } else {
        // no they are not friends so clear array
        //
        //
        arrHomePosts.clear();
      }
    } else if (fetchedAllData['Profile_setting'].toString() == '3') {
      // only me
      if (fetchedAllData['userId'].toString() == strLoginUserId.toString()) {
        //
        // it's me so don't clear the array data.
      } else {
        //
        // set three button hidden
        strHideShowThreeButtons = '1';
        arrHomePosts.clear();
      }
    } else {
      // to all
      //
     
   }*/

    // image or video profile everyone or friends wale condition m show hoga

    if (fetchedAllData['userId'].toString() == strLoginUserId.toString()) {
      if (kDebugMode) {
        print('=============================');
        print('=====> i am login user <=====');
        print('==============================');
      }
      //
      //
      strHideShowThreeButtons = '0';
    } else {
      if (fetchedAllData['Profile_setting'].toString() == '1') {
        // profile is everyone
        if (fetchedAllData['PostPrivacy_setting'].toString() == '2') {
          //
          // check he is my friend or not
          if (fetchedAllData['friendStatus'].toString() == '2') {
            //
            // yes he is my friend
            /*arrHomePosts.clear();
          //
          showLoadingUI(context, 'please wait...');
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
          });*/
            //
          } else {
            //
            arrHomePosts.clear();
            //
            showLoadingUI(context, 'please wait...');
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
          }
        } else if (fetchedAllData['PostPrivacy_setting'].toString() == '3') {
          // Text('post only to me')
          if (fetchedAllData['userId'].toString() ==
              strLoginUserId.toString()) {
            //

            //
          } else {
            //
            arrHomePosts.clear();
            //
            showLoadingUI(context, 'please wait...');
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
          }
        }
      } else if (fetchedAllData['Profile_setting'].toString() == '2') {
        // FRIENDS
        // show only to my friends
        //
        if (fetchedAllData['friendStatus'].toString() == '2') {
          // YES, FRIENDS
          //
          //
          if (fetchedAllData['PostPrivacy_setting'].toString() == '2') {
            // FRIENDS
            //
            // SHOW ALL TABS
            //
            //

            //
          } else if (fetchedAllData['PostPrivacy_setting'].toString() == '3') {
            if (kDebugMode) {
              print(
                  '==================================================================');
              print(
                  '======> PROFILE ( FRIEND ) POST ( ONLY ME ) ( YES, FRIENDS )<========');
              print(
                  '=================================================================');
            }
            //
            //
            showLoadingUI(context, 'please wait...');
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
          }
        } else {
          if (kDebugMode) {
            print('no they are not a friend');
            // profile friends post everyone ( feeds )
          }
          //
          strHideShowThreeButtons = 'show_only_feeds';
          //
        }
        //
      } else if (fetchedAllData['Profile_setting'].toString() == '3') {
        if (fetchedAllData['PostPrivacy_setting'].toString() == '1') {
          if (kDebugMode) {
            print(
                '==================================================================');
            print('======> PROFILE ( ONLY ME ) POST ( ONLY ME ) <========');
            print('======> SHOW ONLY POST <========');
            print(
                '=================================================================');
          }
          if (fetchedAllData['friendStatus'].toString() == '2') {
            if (kDebugMode) {
              print('======================================');
              print('======> YES THEY ARE FRIENDS <========');
            }
            //
            //
            strHideShowThreeButtons = 'show_only_feeds';
            //
          } else if (kDebugMode) {
            print(
                '==================================================================');
            print(
                '======> PROFILE ( ONLY ME ) POST ( ONLY ME ) ( NO FRIENDS) <========');
            print(
                '=================================================================');
          }
        } else if (fetchedAllData['PostPrivacy_setting'].toString() == '2') {
          if (kDebugMode) {
            print(
                '==================================================================');
            print('======> PROFILE ( ONLY ME ) POST ( FRIENDS ) <========');
            print('======> SHOW ONLY POST <========');
            print(
                '=================================================================');
          }
          if (fetchedAllData['friendStatus'].toString() == '2') {
            if (kDebugMode) {
              print('======================================');
              print('======> YES THEY ARE FRIENDS <========');
            }
            //
            //
            strHideShowThreeButtons = 'show_only_feeds';
            //
          } else {
            if (kDebugMode) {
              print(
                  '==================================================================');
              print(
                  '======> PROFILE ( ONLY ME ) POST ( FRIENDS ) ( NO FRIENDS) <========');
              print(
                  '=================================================================');
            }
          }
        } else {
          if (kDebugMode) {
            print('============== ==============================');
            print('======> PROFILE ( ONLY ME ) POST ( ONLY ME ) <========');
            print('======>  HIDE EVERYTHING <========');
            print('============== ===========================');
          }
          //
          //
          strHideShowThreeButtons = '1';
          //
        }

        /*
      if (kDebugMode) {
        print(
            '==================================================================');
        print('======> PROFILE ( ONLY ME ) POST ( EVERYONE ) <========');
        print('======> SHOW ONLY POST <========');
        print(
            '=================================================================');
      }*/
        //
        //
      }
    }

    //
    // profile everyon
    // post friends

    // 3 == 3
    //
    //
    //
    if (mounted == true) {
      setState(() {
        showUI = '1';
        strShowHideUI = '1';
        if (strLikepopupDismiss == '1') {
          Navigator.pop(context);
          strLikepopupDismiss = '0';
        }
        //
        if (strHideWhenPaginationDone == '1') {
          Navigator.pop(context);
          strHideWhenPaginationDone = '0';
        }
      });
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: textWithBoldStyle(
          'Profile',
          Colors.white,
          16.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'popToDashboard');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: navigationColor,
      ),
      body: (strShowHideUI == '0')
          ? Center(
              child: textWithRegularStyle(
                'Please wait',
                Colors.black,
                18.0,
              ),
            )
          : NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (isTop) {
                    if (kDebugMode) {
                      print('At the top 2');
                    }
                    //
                    // setState(() {
                    // shouldShow = '0';
                    // });
                    //
                  } else {
                    if (kDebugMode) {
                      print('At the bottom');
                    }

                    if (strClickFeed == '1') {
                      showLoadingUI(context, 'please wait...');
                      strHideWhenPaginationDone = '1';
                      //
                      newPageControl += 1;
                      if (kDebugMode) {
                        print(
                            '================ PAGE CONTROL=====================');
                        print('=====================================');
                        print(newPageControl);
                        print('=====================================');
                        print('=====================================');
                      }
                      //
                      getOtherUserProfileData(newPageControl);
                    }
                  }
                }
                return true;
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: Stack(
                        children: [
                          //
                          if (fetchedAllData['ProfilePicture_setting']
                                  .toString() ==
                              '1') ...[
                            if (fetchedAllData['image'].toString() == '')
                              //
                              avatarProfileBGUI()
                            //
                            else
                              //
                              realProfileBGUI()
                            //
                          ] else if (fetchedAllData['ProfilePicture_setting']
                                  .toString() ==
                              '2') ...[
                            // status 2 => we are friends
                            //

                            if (fetchedAllData['friendStatus'].toString() ==
                                '0') ...[
                              //
                              avatarProfileBGUI()
                              // Text('27'),
                              //
                            ] else ...[
                              // yes he / she is friend
                              if (fetchedAllData['image'].toString() == '')
                                //
                                avatarProfileBGUI()
                              // Text('28')
                              else
                                //
                                realProfileBGUI()
                              // Text('29'),
                              //
                            ]

                            //
                          ] else if (fetchedAllData['ProfilePicture_setting']
                                  .toString() ==
                              '3') ...[
                            // my DP is not visible to any one
                            //
                            if (fetchedAllData['image'].toString() == '')
                              //
                              avatarProfileBGUI()
                            //
                            else
                            //
                            if (fetchedAllData['userId'].toString() ==
                                strLoginUserId.toString()) ...[
                              realProfileBGUI()
                              // Text('1')
                            ] else ...[
                              avatarProfileBGUI()
                              // Text('2')
                            ]

                            //
                          ],

                          //
                          bottomProfileImageAndNameWithTagUI(),
                          //
                        ],
                      ),
                    ),
                    //
                    //
                    showPostFriendsUI(context),
                    //

                    // three button show
                    if (strHideShowThreeButtons == '0') ...[
                      //
                      //
                      threeButtonsSelectForProfile2(context),
                      //
                    ] /* else if (strHideShowThreeButtons == '0') ...[
                      //
                      // hide three button UI
                    ] */
                    else if (strHideShowThreeButtons == 'show_only_feeds') ...[
                      //
                      // show only feeds tab
                      showOnlyPostTabFromThreeUI(context),
                    ],

                    ///
                    ///

                    if (strHideShowThreeButtons == '1') ...[
                      const SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Icon(
                            Icons.lock,
                          ),
                        ),
                      )
                    ] else ...[
                      if (strClickFeed == '1') ...[
                        for (int i = 0; i < arrHomePosts.length; i++) ...[
                          if (arrHomePosts[i]['postType'].toString() ==
                              'Text') ...[
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
                              likeCommentShareUI(context, i),
                              //
                            ]
                          ] else if (arrHomePosts[i]['postType'].toString() ==
                              'Map') ...[
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
                              likeCommentShareUI(context, i),
                            ] else ...[
                              //
                              // header = > image , name , time
                              commonHeaderForAllCellTypesUI(
                                  context, i, ' shared location'),
                              //
                              //
                              //
                              //
                              if (arrHomePosts[i]['message'].split(',')[2] ==
                                  '')
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
                                )
                              ],

                              HomeNewSharedMapUIScreen(
                                getDataSharedMapUIWithIndex: arrHomePosts[i],
                              ),
                              //
                              // like , comment and share
                              likeCommentShareUI(context, i),
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
                              likeCommentShareUI(context, i),
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
                                getDataSharedImageDataWithIndex:
                                    arrHomePosts[i],
                              ),
                              //
                              // like , comment and share
                              likeCommentShareUI(context, i),
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
                              likeCommentShareUI(context, i),
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
                              likeCommentShareUI(context, i),
                            ]
                          ],
                          Container(
                            height: 0.6,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                          ),
                        ]
                      ] else if (strClickImages == '1') ...[
                        //
                        //
                        // showLoadingUI
                        // UserNewProfileImagesScreen(getImageFullArray: arrImageList),

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
                                showImageViewerPager(
                                    context, customImageProvider,
                                    doubleTapZoomable: true,
                                    onPageChanged: (page) {
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
                      ] else if (strClickVideos == '1') ...[
                        //
                        // funcLoadAllImages('Video'),
                        // UserNewProfileImagesScreen(getImageFullArray: arrImageList),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeNewPlayVideoScreen(
                                      getURL: arrImageList[index]['image']
                                          .toString(),
                                    ),
                                  ),
                                );
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
                                child: const Icon(
                                  Icons.play_arrow,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ],

                    //

                    //
                  ],
                ),
              ),
            ),
    );
  }

  Padding bottomProfileImageAndNameWithTagUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                if (fetchedAllData['ProfilePicture_setting'].toString() ==
                    '1') ...[
                  if (fetchedAllData['image'].toString() == '')
                    //
                    avatarProfileUI()
                  //
                  else
                    //
                    realProfileUI()
                  //
                ] else if (fetchedAllData['ProfilePicture_setting']
                        .toString() ==
                    '2') ...[
                  // status 2 => we are friends
                  //

                  if (fetchedAllData['friendStatus'].toString() == '0') ...[
                    //
                    avatarProfileUI()
                    // Text('27'),
                    //
                  ] else ...[
                    // yes he / she is friend
                    if (fetchedAllData['image'].toString() == '')
                      //
                      avatarProfileUI()
                    // Text('28')
                    else
                      //
                      realProfileUI()
                    // Text('29'),
                    //
                  ]

                  //
                ] else if (fetchedAllData['ProfilePicture_setting']
                        .toString() ==
                    '3') ...[
                  // my DP is not visible to any one
                  //
                  if (fetchedAllData['image'].toString() == '')
                    //
                    avatarProfileUI()
                  //
                  else
                  //
                  if (fetchedAllData['userId'].toString() ==
                      strLoginUserId.toString()) ...[
                    realProfileUI()
                  ] else ...[
                    avatarProfileUI()
                  ]

                  //
                ],
                /*if (fetchedAllData['ProfilePicture_setting'].toString() ==
                    '1') ...[
                  if (fetchedAllData['image'].toString() == '')
                    //
                    avatarProfileUI()
                  //
                  else
                    //
                    realProfileUI()
                  //
                ] else if (fetchedAllData['ProfilePicture_setting']
                        .toString() ==
                    '2') ...[
                  // status 2 => we are friends
                  //
                  if (fetchedAllData['Userimage'].toString() == '')
                    //
                    avatarProfileUI()
                  else
                    (fetchedAllData['SettingProfilePicture'].toString() == '3')
                        ? avatarProfileUI()
                        : realProfileUI()
                  //
                ] else if (fetchedAllData['ProfilePicture_setting']
                        .toString() ==
                    '3') ...[
                  // my DP is not visible to any one
                  //
                  if (fetchedAllData['image'].toString() == '')
                    //   //
                    avatarProfileUI()
                  // //
                  else
                    (strLoginUserId == fetchedAllData['userId'].toString())
                        ? realProfileUI()
                        : avatarProfileUI()
                  //
                ],*/

                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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

                //
              ],
            ),
          ],
        ),
      ),
    );
  }

//
// UI = > AVATAR PHOTO UI
  Container avatarProfileUI() {
    return Container(
      margin: const EdgeInsets.only(left: 0.0),
      width: 54,
      height: 54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          40.0,
        ),
        child: Image.asset(
          'assets/icons/avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //
// UI = > AVATAR PHOTO UI
  Container avatarProfileBGUI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Opacity(
        opacity: 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            40.0,
          ),
          child: Image.asset(
            'assets/icons/avatar.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

//
// UI = > REAL PHOTO UI
  Container realProfileUI() {
    return Container(
      margin: const EdgeInsets.only(left: 0.0),
      width: 54,
      height: 54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          40.0,
        ),
        child: Image.network(
          fetchedAllData['image'].toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //
// UI = > REAL PHOTO UI
  Container realProfileBGUI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Opacity(
        opacity: 0.4,
        child: Image.network(
          fetchedAllData['image'].toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container profileimageBigUI(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Opacity(
        opacity: 0.4,
        child: Image.network(
          fetchedAllData['image'].toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container showPostFriendsUI(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: //
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
                  : (fetchedAllData['friendStatus'].toString() == '2')
                      ? Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              //
                              if (kDebugMode) {
                                // print(FirebaseAuth
                                // .instance.currentUser!.uid);
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                      : (fetchedAllData['friendStatus'].toString() == '')
                          ? Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  //
                                  addFriendWB();
                                  //
                                },
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
                          : (fetchedAllData['friendUserId'].toString() ==
                                  strLoginUserId.toString())
                              ? Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(
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
      // child:

      /*Stack(
                children: [
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
                                          blockUserWB(fetchedAllData['userId']
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
                                    //
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
                                    //
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
              ),*/
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
            likeCommentShareUI(context, i),
            //
          ],
        ),
      ),
    );
  }

  Container likeCommentShareUI(BuildContext context, serverData) {
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
          /*Expanded(
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
          ),*/
        ],
      ),
    );
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

    (arrHomePosts[getDataToLikeThatCell]['like_status'].toString() == 'no')
        ? homeLikeUnlikeApiCall
            .homeLikeUnlikeWB(
              strLoginUserId.toString(),
              arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
              '0',
            )
            .then((value) => {
                  // funcSendUserIdToGetHomeData(
                  //   strGetUserId.toString(),
                  //   'no',
                  //   pageControl,
                  // ),
                  if (mounted == true)
                    {
                      setState(() {
                        Navigator.pop(context);
                      }),
                    }
                })
        : homeLikeUnlikeApiCall
            .homeLikeUnlikeWB(
              strLoginUserId.toString(),
              arrHomePosts[getDataToLikeThatCell]['postId'].toString(),
              '1',
            )
            .then((value) => {
                  // funcSendUserIdToGetHomeData(
                  //   strGetUserId.toString(),
                  //   'no',
                  //   pageControl,
                  // ),
                  if (mounted == true)
                    {
                      setState(() {
                        Navigator.pop(context);
                      }),
                    }
                });
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
            if (arrHomePosts[serverData]['friendStatus'].toString() == '' ||
                arrHomePosts[serverData]['friendStatus'].toString() == '0') ...[
              //
              onlyAvataProfilePictureUI(serverData)
              //
            ] else ...[
              //
              profilePictureShowUI(serverData)
              //
            ]
            // if (arrHomePosts[serverData]['Userimage'].toString() == '')
            //
            // onlyAvataProfilePictureUI(serverData)
            //
            // else
            // profilePictureShowUI(serverData)
            /*(arrHomePosts[serverData]['userId'].toString() ==
                      strLoginUserId.toString())
                  ? onlyAvataProfilePictureUI(serverData)
                  : profilePictureShowUI(serverData)*/
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
              (strLoginUserId == arrHomePosts[serverData]['userId'].toString())
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
                if (kDebugMode) {
                  print(serverData);
                }

                (strLoginUserId ==
                        arrHomePosts[serverData]['userId'].toString())
                    ? funcDeletePostPopup(serverData)
                    : funcReportPopup(serverData);
                // funcReportThisPost(serverData);
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
        // funcPushToUserProfile(
        //   arrHomePosts[serverData]['userId'].toString(),
        // );
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
      print('=====> POST : DELETE POST');
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
          'userId': strLoginUserId.toString(),
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
              ],
            ),
          ),
        );
      },
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

  Column threeButtonsSelectForProfile2(BuildContext context) {
    return Column(
      children: [
        if (fetchedAllData['userId'].toString() ==
            strLoginUserId.toString()) ...[
          //
          showAllTabsUI(context),
          //
        ] else ...[
          if (fetchedAllData['PostPrivacy_setting'].toString() == '1') ...[
            //
            showAllTabsUI(context),
            //
          ] else if (fetchedAllData['PostPrivacy_setting'].toString() ==
              '2') ...[
            //
            // check he is my friend or not
            if (fetchedAllData['friendStatus'].toString() == '2') ...[
              //
              // yes he is my friend
              showAllTabsUI(context),

              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
            ] else ...[
              //
              //
              showOnlyImageAndVideo(context),
              //
            ]
          ] else if (fetchedAllData['PostPrivacy_setting'].toString() ==
              '3') ...[
            // Text('post only to me')
            if (fetchedAllData['userId'].toString() ==
                strLoginUserId.toString()) ...[
              //
              showAllTabsUI(context),
              //
            ] else ...[
              //
              showOnlyImageAndVideo(context),
            ]
          ],
        ]
      ],
    );
  }

  Container showAllTabsUI(BuildContext context) {
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
                showLoadingUI(context, 'please wait...');
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
                showLoadingUI(context, 'please wait...');
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

  Container showOnlyImageAndVideo(BuildContext context) {
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
          //
          Expanded(
            child: InkWell(
              onTap: () {
                if (kDebugMode) {
                  print('click images =====> $strClickImages');
                }
                showLoadingUI(context, 'please wait...');
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
                showLoadingUI(context, 'please wait...');
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

  Container showOnlyPostTabFromThreeUI(BuildContext context) {
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

                // if (kDebugMode) {
                //   print(arrImageList);
                //   print(arrImageList.length);
                // }
                for (int i = 0; i < arrImageList.length; i++) {
                  // print(arrImageList[i]);

                  arr_scroll_multiple_images.add(arrImageList[i]['image']);
                }
                //
                Navigator.pop(context);
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
          'userId': strLoginUserId.toString(),
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

        if (mounted == true) {
          setState(() {
            Navigator.pop(context);
          });
        }
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
}
