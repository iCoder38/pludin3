import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_image_UI/home_feeds_image_UI.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_text_UI/home_feeds_text_UI.dart';
import 'package:pludin/classes/controllers/home/home_like_modal/home_like_modal.dart';
// import 'package:pludin/classes/controllers/home/home_modal/home_modal.dart';
import 'package:pludin/classes/controllers/profile/my_profile_feeds/profile_new_feeds_modal/profile_new_feeds.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../database/database_helper.dart';
import '../../home/home_feeds_comment/home_feeds_comments.dart';
import '../../home/home_feeds_for_location/home_feeds_for_location.dart';
import '../../home/home_feeds_shared_location/home_feed_shared_location.dart';
import '../my_profile.dart';

import 'package:timeago/timeago.dart' as timeago;

class MyProfileFeeds extends StatefulWidget {
  const MyProfileFeeds(
      {super.key,
      required this.strFetchUserId,
      required this.strFetchFriendUserId,
      required this.strCheckIsHeMyFriend});

  final String strFetchFriendUserId;
  final String strFetchUserId;
  final String strCheckIsHeMyFriend;

  @override
  State<MyProfileFeeds> createState() => _MyProfileFeedsState();
}

class _MyProfileFeedsState extends State<MyProfileFeeds> {
  //
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strLikePress = '0';
  var strHomeloader = '0';
  //
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  //
  var strPlayPause = '0';
  //
  final homeLikeUnlikeApiCall = HomeLikeModal();
  final homeNewApiCall = HomeNEWModal();
  var arrHomePosts = [];
  //
  var strListVideoPlay = '0';
  late VideoPlayerController _controller2;
  late Future<void> _initializeVideoPlayerFuture2;
  //
  var strImageCount = 0;
  //
  late int currentIndex;
  //
  late DataBase handler;
  //
  var strUserSelectMainSetting = '0';
  var strUserSelectSettingProfile = '0';
  var strRealLoginUserId = '';
  var hidePopup = '0';
//
  //
  @override
  void initState() {
    super.initState();
    //
    if (kDebugMode) {}
    //
    handler = DataBase();
    //
    funcLoginUserRealDataGetFromLocalDB();
    //
    funcSendUserIdToGetHomeData(
      widget.strFetchUserId,
    );
    //
  }

  funcLoginUserRealDataGetFromLocalDB() {
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
                    strRealLoginUserId = value[i].userId.toString(),
                    // strLoginUserImage = value[i].image.toString(),
                    // print(strLoginUserImage),
                    //
                  },
                //

                //
              });
        }
      },
    );
    //
  }

  funcSendUserIdToGetHomeData(strLoginUserId) {
    homeNewApiCall
        .homeNEWWB(
      strLoginUserId.toString(),
      'Other',
      widget.strFetchFriendUserId.toString(),
    )
        .then((value1) {
      if (kDebugMode) {
        print('Friends id ==========> ${widget.strFetchFriendUserId}');
        print('Login user id ==========> ${widget.strFetchUserId}');
        print('=========================== 1');
        print('=========================== 1');
        print(value1);
        print(value1.length);
        strUserSelectSettingProfile =
            value1[0]['SettingProfilePicture'].toString();
        strUserSelectMainSetting = value1[0]['SettingProfile'].toString();
        print(
            'User Setting Profile Picture =====> $strUserSelectSettingProfile');
        print('User Main Setting =====> $strUserSelectMainSetting');
        print('=========================== 2');
        print('=========================== 2');
      }
      //

      arrHomePosts.clear();

      //
      for (int i = 0; i < value1.length; i++) {
        arrHomePosts.add(value1[i]);
      }

      if (kDebugMode) {
        print(arrHomePosts.length);
      }

      setState(() {
        if (strLikePress == '1') {
          Navigator.pop(context);
        }
        //
        if (hidePopup == '1') {
          Navigator.pop(context);
          hidePopup = '0';
        }
        strHomeloader = '1';
      });
    });
  }

  // 1 = everyone
  // 2 = Friends
  // 3 = only me

  @override
  Widget build(BuildContext context) {
    // if (strHomeloader == '0') {
    // return const CircularProgressIndicator();
    // } else {
    if (strUserSelectMainSetting == '3') {
      return Center(
        child: textWithRegularStyle(
          '',
          Colors.black,
          14.0,
        ),
      );
    } else if (strUserSelectMainSetting == '2') {
      // return
      if (widget.strCheckIsHeMyFriend == 'yes_friends') {
        const CircularProgressIndicator();
        return myProfileFeedsFullUI(context);
      } else {
        return textWithRegularStyle(
          '',
          Colors.black,
          14.0,
        );
      }
    } else {
      const CircularProgressIndicator();
      return myProfileFeedsFullUI(context);
    }
    // }
  }

  SingleChildScrollView myProfileFeedsFullUI(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (int i = 0; i < arrHomePosts.length; i++) ...[
            if (strHomeloader == '0')
              Center(
                child: textWithRegularStyle(
                  'No data',
                  Colors.black,
                  22.0,
                ),
              )
            else if (arrHomePosts[i]['postType'] == 'Image') ...[
              //
              if (arrHomePosts[i]['share'] == null) ...[
                deletePostWB(context, i),
                //
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
                    itemCount: arrHomePosts[i]['postImage'].length,
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

                          Container(
                            margin: const EdgeInsets.all(10),
                            // height: 240,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: i == currentIndex
                                    ? Colors.white
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            // child:
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                24.0,
                              ),
                              child: Image.network(
                                //
                                arrHomePosts[i]['postImage'][pagePosition]
                                    ['name'],
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                  '$currentIndex / ${arrHomePosts[i]['postImage'].length}',
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
                //pageind

                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 0.0,
                            left: 8,
                            bottom: 8,
                          ),
                          color: Colors.transparent,
                          width: 48.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (kDebugMode) {
                                    print('like click 2');
                                    print(
                                        arrHomePosts[i]['youliked'].toString());
                                    print(arrHomePosts[i]['postId'].toString());
                                  }
                                  //

                                  strLikePress = '1';
                                  //
                                  QuickAlert.show(
                                    context: context,
                                    barrierDismissible: false,
                                    type: QuickAlertType.loading,
                                    title: 'Please wait...',
                                    text: '',
                                    onConfirmBtnTap: () {
                                      if (kDebugMode) {
                                        print('some click');
                                      }
                                      //
                                    },
                                  );
                                  //

                                  (arrHomePosts[i]['youliked'].toString() ==
                                          'No')
                                      ? homeLikeUnlikeApiCall
                                          .homeLikeUnlikeWB(
                                            widget.strFetchUserId.toString(),
                                            arrHomePosts[i]['postId']
                                                .toString(),
                                            '1',
                                          )
                                          .then((value) => {
                                                funcSendUserIdToGetHomeData(
                                                  widget.strFetchUserId
                                                      .toString(),
                                                ),
                                              })
                                      : homeLikeUnlikeApiCall
                                          .homeLikeUnlikeWB(
                                            widget.strFetchUserId.toString(),
                                            arrHomePosts[i]['postId']
                                                .toString(),
                                            '2',
                                          )
                                          .then((value) => {
                                                funcSendUserIdToGetHomeData(
                                                  widget.strFetchUserId
                                                      .toString(),
                                                ),
                                              });
                                },
                                icon: (arrHomePosts[i]['youliked'].toString() ==
                                        'No')
                                    ? const Icon(
                                        Icons.favorite_border,
                                        size: 28,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                        size: 28,
                                      ),
                              ),

                              //
                              textWithRegularStyle(
                                '${arrHomePosts[i]['likesCount'].toString()} like',
                                Colors.black,
                                14.0,
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                      //
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeFeedsCommentsScreen(
                                  getDataForComment: arrHomePosts[i],
                                ),
                              ),
                            );
                            //
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 0.0,
                              left: 8,
                              bottom: 8,
                            ),
                            color: Colors.transparent,
                            width: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (kDebugMode) {
                                      print('object 1.0');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.mode_comment_outlined,
                                    size: 24,
                                  ),
                                ),
                                //
                                textWithRegularStyle(
                                  'comment',
                                  Colors.black,
                                  12.0,
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 0.0,
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          color: Colors.transparent,
                          width: 48.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (kDebugMode) {
                                    print('share click image');
                                  }
                                  //
                                  // setState(() {
                                  //   contWriteSomething.text = '';
                                  //   strPostType = '6';
                                  //   strTextCount = '0';
                                  //   //
                                  //   sharedPostType = 'Image';
                                  //   sharedDataStored = arrHomePosts[i];
                                  // });
                                  //
                                },
                                icon: const Icon(
                                  Icons.share_outlined,
                                  size: 28,
                                ),
                              ),
                              //
                              textWithRegularStyle(
                                'share',
                                Colors.black,
                                14.0,
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ] else ...[
                //
                feedsImageNotSharedUI(context, i),
                //
                likePostStructureUI(context, i)
                //
              ]
              //
            ] else if (arrHomePosts[i]['postType'] == 'Video') ...[
              //
              if (arrHomePosts[i]['share'] != null) ...[
                //
                videoSharedContentUI(context, i),
                //
                videoSharedContentLikeCommentShareUI(context, i),
                //
              ] else ...[
                deletePostWB(context, i),
                //

                InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print(arrHomePosts[i]['postImage']);
                    }

                    funcPlayVideo(arrHomePosts[i]['postImage'][0]['name']);
                    // _controller2.play();
                    //
                    /*
                    */
                    videoPlayPopUPUI(context);
                  },
                  child: FutureBuilder(
                    future: func(
                      arrHomePosts[i]['postImage'][0]['name'].toString(),
                    ),
                    builder: (context, snapshot) {
                      // f (snapshot.connectionState ==
                      // ConnectionState.done) {
                      return Container(
                        // margin: const EdgeInsets.all(10.0),
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            //
                            Container(
                              // margin: const EdgeInsets.all(10.0),
                              color: Colors.purple,
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child: (snapshot.data == null)
                                  ? Image.asset(
                                      'assets/icons/avatar.png',
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

                Container(
                  // margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 0.0,
                            left: 8,
                            bottom: 8,
                          ),
                          color: Colors.transparent,
                          width: 48.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (kDebugMode) {
                                    print('like click 2');
                                    print(
                                        arrHomePosts[i]['youliked'].toString());
                                    print(arrHomePosts[i]['postId'].toString());
                                  }
                                  //

                                  strLikePress = '1';
                                  //
                                  QuickAlert.show(
                                    context: context,
                                    barrierDismissible: false,
                                    type: QuickAlertType.loading,
                                    title: 'Please wait...',
                                    text: '',
                                    onConfirmBtnTap: () {
                                      if (kDebugMode) {
                                        print('some click');
                                      }
                                      //
                                    },
                                  );
                                  //

                                  (arrHomePosts[i]['youliked'].toString() ==
                                          'No')
                                      ? homeLikeUnlikeApiCall
                                          .homeLikeUnlikeWB(
                                            widget.strFetchUserId.toString(),
                                            arrHomePosts[i]['postId']
                                                .toString(),
                                            '1',
                                          )
                                          .then((value) => {
                                                funcSendUserIdToGetHomeData(
                                                  widget.strFetchUserId
                                                      .toString(),
                                                ),
                                              })
                                      : homeLikeUnlikeApiCall
                                          .homeLikeUnlikeWB(
                                            widget.strFetchUserId.toString(),
                                            arrHomePosts[i]['postId']
                                                .toString(),
                                            '2',
                                          )
                                          .then((value) => {
                                                funcSendUserIdToGetHomeData(
                                                  widget.strFetchUserId
                                                      .toString(),
                                                ),
                                              });
                                },
                                icon: (arrHomePosts[i]['youliked'].toString() ==
                                        'No')
                                    ? const Icon(
                                        Icons.favorite_border,
                                        size: 28,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                        size: 28,
                                      ),
                              ),
                              //
                              textWithRegularStyle(
                                '${arrHomePosts[i]['likesCount'].toString()} like',
                                Colors.black,
                                14.0,
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                      //
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeFeedsCommentsScreen(
                                  getDataForComment: arrHomePosts[i],
                                ),
                              ),
                            );
                            //
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 0.0,
                              left: 8,
                              bottom: 8,
                            ),
                            color: Colors.transparent,
                            // width: 60.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (kDebugMode) {
                                      print('object');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.mode_comment_outlined,
                                    size: 24,
                                  ),
                                ),
                                //
                                textWithRegularStyle(
                                  'comment',
                                  Colors.black,
                                  12.0,
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 0.0,
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          color: Colors.transparent,
                          width: 48.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (kDebugMode) {
                                    print('share click video');
                                  }

                                  // setState(() {
                                  //   // print('object1');
                                  //   contWriteSomething.text = '';
                                  //   strPostType = '7';
                                  //   strTextCount = '0';
                                  //   sharedPostType = 'Video';
                                  //   //
                                  //   sharedDataStored = arrHomePosts[i];
                                  //   //
                                  // });
                                },
                                icon: const Icon(
                                  Icons.share_outlined,
                                  size: 28,
                                ),
                              ),
                              //
                              textWithRegularStyle(
                                'share',
                                Colors.black,
                                14.0,
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ],
              //
            ] else if (arrHomePosts[i]['postType'] == 'Text') ...[
              // text
              // text
              if (arrHomePosts[i]['share'] != null) ...[
                //
                textSharedContentUI(context, i),
                //
                likePostStructureUI(context, i)
                //
              ] else if (arrHomePosts[i]['share'] == null) ...[
                // CHECK IF THIS TEXT POST IS SHARED OR NOT
                if (arrHomePosts[i]['share'] == null) ...[
                  textDataIsNormalUI(context, i), // normal data
                ] else ...[
                  // sharedTextDataUI(context, i), // shared data
                ],
                //
                likePostStructureUI(context, i),
                //
              ]
            ] else if (arrHomePosts[i]['postType'] == 'Map') ...[
              //
              if (arrHomePosts[i]['share'] == null) ...[
                //
                locationNotSharedHeaderUI(context, i),
                HomeFeedsForLocation(getData: arrHomePosts[i]),
                likeCommentShareInMap(context, i),
                //
              ] else ...[
                // If someone shared someone's location
                // locationNotSharedHeaderUI(context, i),
                whenUserSharedSomeoneElseLocationUI(context, i),
                //
                likeCommentShareInMap(context, i),
                //
              ]
              //
            ],

            // separator line
            Container(
              // margin: const EdgeInsets.all(10.0),
              color: const Color.fromRGBO(
                240,
                240,
                240,
                1,
              ),
              width: MediaQuery.of(context).size.width,
              height: 10,
            ),
            //
          ],
        ],
      ),
    );
  }

  Padding whenUserSharedSomeoneElseLocationUI(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(),
        ),
        child: Column(
          children: [
            //
            locationNotSharedHeaderUI(context, i),
            //
            if (arrHomePosts[i]['message'].toString() == '')
              ...[]
            else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    arrHomePosts[i]['message']..toString(),
                  ),
                ),
              ),
            ],
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 350,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.4),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 188, 182, 182),
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    //
                    locationSharedAndSetImageProfileWithNameHeaderUI(
                        context, i),
                    //
                    if (arrHomePosts[i]['share']['message'].split(',')[2] == '')
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            arrHomePosts[i]['share']['message'].split(',')[2],
                          ),
                        ),
                      ),
                    ],

                    Container(
                      // margin: const EdgeInsets.all(10.0),
                      color: Colors.pink[600],
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      child: GoogleMap(
                        //onMapCreated: _onMapCreated,
                        onMapCreated: (controller) => Marker(
                          markerId: const MarkerId('My Location'),
                          position: LatLng(
                            double.parse(arrHomePosts[i]['share']['message']
                                .split(',')[0]),
                            double.parse(arrHomePosts[i]['share']['message']
                                .split(',')[1]),
                          ),
                          // icon: BitmapDescriptor.,
                          infoWindow: const InfoWindow(
                            title: 'qwer',
                            snippet: 'address',
                          ),
                        ),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(arrHomePosts[i]['share']['message']
                                .split(',')[0]),
                            double.parse(arrHomePosts[i]['share']['message']
                                .split(',')[1]),
                          ),
                          zoom: 14.0,
                        ),
                        markers: markers.values.toSet(),
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container locationSharedAndSetImageProfileWithNameHeaderUI(
      BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(10.0),

      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                30,
              ),
              image: (arrHomePosts[i]['share']['userImage'].toString() == '')
                  ? const DecorationImage(
                      image: AssetImage(
                        'assets/icons/avatar.png',
                      ),
                      fit: BoxFit.fitHeight,
                    )
                  : DecorationImage(
                      image: NetworkImage(
                        arrHomePosts[i]['share']['userImage'].toString(),
                      ),
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
          /*if (widget.strFetchUserId ==
              arrHomePosts[i]['userId'].toString()) ...[
            //
            // matchImageUserLoginProfilematched(i),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  30,
                ),
                image: (arrHomePosts[i]['share']['userImage'].toString() == '')
                    ? const DecorationImage(
                        image: AssetImage(
                          'assets/icons/avatar.png',
                        ),
                        fit: BoxFit.fitHeight,
                      )
                    : DecorationImage(
                        image: NetworkImage(
                          arrHomePosts[i]['share']['userImage'].toString(),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
              ),
            )
            //
          ] else if (arrHomePosts[i]['friendStatus'].toString() == '0' ||
              arrHomePosts[i]['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (arrHomePosts[i]['SettingProfilePicture'].toString() == '1') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: (arrHomePosts[i]['share']['userImage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            arrHomePosts[i]['share']['userImage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '2') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/icons/avatar.png',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '3') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/icons/avatar.png',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              //
            ],
          ] else if (arrHomePosts[i]['friendStatus'].toString() == '2') ...[
            // THEY BOTH ARE FRIENDS
            if (arrHomePosts[i]['SettingProfilePicture'].toString() == '1') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: (arrHomePosts[i]['share']['userImage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            arrHomePosts[i]['share']['userImage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '2') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: (arrHomePosts[i]['share']['userImage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            arrHomePosts[i]['share']['userImage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '3') ...[
              //
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/icons/avatar.png',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              //
            ],
          ],*/

          //

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print(
                        'name 2',
                      );
                    }
                    //
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(
                          strUserId: arrHomePosts[i]['userId'].toString(),
                        ),
                      ),
                    );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: arrHomePosts[i]['share']['userName'].toString(),
                      //
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: ' shared location',
                          style: TextStyle(
                            color: Color.fromRGBO(
                              131,
                              131,
                              131,
                              1,
                            ),
                            fontSize: 14.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        //
                        TextSpan(
                          text: '\n${timeago.format(
                            DateTime.parse(
                              arrHomePosts[i]['share']['created'].toString(),
                            ),
                          )}',
                          style: const TextStyle(
                            color: Color.fromRGBO(
                              210,
                              210,
                              210,
                              1,
                            ),
                            fontSize: 12.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //

          //
        ],
      ),
      // child: widget
    );
  }

  Container likeCommentShareInMap(BuildContext context, int i) {
    return Container(
      // margin: const EdgeInsets.all(10.0),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('like click 2');
                        print(arrHomePosts[i]['youliked'].toString());
                        print(arrHomePosts[i]['postId'].toString());
                      }
                      //

                      strLikePress = '1';
                      //
                      QuickAlert.show(
                        context: context,
                        barrierDismissible: false,
                        type: QuickAlertType.loading,
                        title: 'Please wait...',
                        text: '',
                        onConfirmBtnTap: () {
                          if (kDebugMode) {
                            print('some click');
                          }
                          //
                        },
                      );
                      //

                      (arrHomePosts[i]['youliked'].toString() == 'No')
                          ? homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  });
                    },
                    icon: (arrHomePosts[i]['youliked'].toString() == 'No')
                        ? const Icon(
                            Icons.favorite_border,
                            size: 28,
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                  ),
                  //
                  textWithRegularStyle(
                    '${arrHomePosts[i]['likesCount'].toString()} like',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
          Expanded(
            child: InkWell(
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeFeedsCommentsScreen(
                      getDataForComment: arrHomePosts[i],
                    ),
                  ),
                );
                //
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 0.0,
                  left: 8,
                  bottom: 8,
                ),
                color: Colors.transparent,
                // width: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('object');
                        }
                      },
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        size: 24,
                      ),
                    ),
                    //
                    textWithRegularStyle(
                      'comment',
                      Colors.black,
                      12.0,
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                right: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('share click text ');
                      }
//
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 28,
                    ),
                  ),
                  //
                  textWithRegularStyle(
                    'share',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Container feedsImageNotSharedUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(
        10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(),
      ),
      child: Column(
        children: [
          Container(
            // height: 350,
            width: MediaQuery.of(context).size.width,

            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Row(
                    children: [
                      if (widget.strFetchUserId ==
                          arrHomePosts[i]['userId'].toString()) ...[
                        //
                        matchImageUserLoginProfilematchedSHARE_image(i),
                        //
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                              '0' ||
                          arrHomePosts[i]['friendStatus'].toString() ==
                              '1') ...[
                        // 0 = no friend
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsNoFriendAndProfileSetToEveryoneSHAREImage(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyFriendsSHARE(),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyMeSHARE(),
                          //
                        ],
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                          '2') ...[
                        // THEY BOTH ARE FRIENDS
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsYesFriendAndProfileSetToEveryoneSHARE(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyFriendsSHARE(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyMeSHARE(),
                          //
                        ],
                      ],

                      //

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                if (kDebugMode) {
                                  print(
                                    'name 2',
                                  );
                                }
                                //
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfileScreen(
                                      strUserId:
                                          arrHomePosts[i]['userId'].toString(),
                                    ),
                                  ),
                                );
                                //
                              },
                              child: RichText(
                                text: TextSpan(
                                  //
                                  text: arrHomePosts[i]['fullName'].toString(),
                                  //
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: ' shared some image ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                          131,
                                          131,
                                          131,
                                          1,
                                        ),
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //
                                    TextSpan(
                                      text: '\n${timeago.format(
                                        DateTime.parse(
                                          arrHomePosts[i]['created'].toString(),
                                        ),
                                      )}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(
                                          210,
                                          210,
                                          210,
                                          1,
                                        ),
                                        fontSize: 12.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //
                      (widget.strFetchUserId.toString() ==
                              arrHomePosts[i]['userId'].toString())
                          ? IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('open action sheet');
                                }
                                //
                                deletePostFromMenu(
                                  context,
                                  arrHomePosts[i]['postId'].toString(),
                                );
                                //
                              },
                              icon: const Icon(
                                Icons.menu,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('open action sheet');
                                }
                                //
                                blockUserPostFromMenu(context,
                                    arrHomePosts[i]['postId'].toString());
                                //
                              },
                              icon: const Icon(
                                Icons.menu,
                              ),
                            )
                    ],
                  ),
                  // child: widget
                ),

                Container(
                  margin: const EdgeInsets.only(
                    left: 50.0,
                    top: 0.0,
                    bottom: 10.0,
                    right: 10.0,
                  ),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  // height: 220,
                  child: ReadMoreText(
                    //
                    arrHomePosts[i]['message'].toString(),
                    // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                    //
                    trimLines: 4,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Show more',
                    trimExpandedText: '...Show less',
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //
              ],
            ),
          ),
          //
          shardImageDataUI(context, i),
          //
        ],
      ),
    );
  }

  Container shardImageDataUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        left: 10.0,
      ),
      // height: 350,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    image: (arrHomePosts[i]['share']['userImage'].toString() ==
                            '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              arrHomePosts[i]['share']['userImage'].toString(),
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                ),

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['share']['userId']
                                    .toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text:
                                arrHomePosts[i]['share']['userName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text: ' shared some image',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n46 min ago',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
              ],
            ),
            // child: widget
          ),

          if (arrHomePosts[i]['message'].toString() == '')
            ...[]
          else ...[
            if (arrHomePosts[i]['share']['message'].toString() == '')
              ...[]
            else ...[
              Container(
                margin: const EdgeInsets.only(
                  left: 50.0,
                  top: 0.0,
                  bottom: 10.0,
                  right: 10.0,
                ),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                // height: 220,
                child: ReadMoreText(
                  //
                  arrHomePosts[i]['share']['message'].toString(),
                  // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                  //
                  trimLines: 4,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: '...Show less',
                  moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
          ],

          //
          Container(
            // height: 40,

            width: MediaQuery.of(context).size.width,

            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
            ),
            child: Container(
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
                itemCount: arrHomePosts[i]['share']['postImage'].length,
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

                      Container(
                        margin: const EdgeInsets.all(10),
                        // height: 240,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            // color: i == currentIndex
                            //     ? Colors.white
                            //     : Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        // child:
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            24.0,
                          ),
                          child: Image.network(
                            //
                            arrHomePosts[i]['share']['postImage'][pagePosition]
                                ['name'],
                            //
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
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
                              '$currentIndex / ${arrHomePosts[i]['share']['postImage'].length}',
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
          ),
          //
        ],
      ),
    );
  }

  Container locationNotSharedHeaderUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          if (widget.strFetchUserId ==
              arrHomePosts[i]['userId'].toString()) ...[
            //
            matchImageUserLoginProfilematched(i),
            //
          ] else if (arrHomePosts[i]['friendStatus'].toString() == '0' ||
              arrHomePosts[i]['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (arrHomePosts[i]['SettingProfilePicture'].toString() == '1') ...[
              //
              userIsNoFriendAndProfileSetToEveryone(i),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '2') ...[
              //
              userIsNoFriendAndProfileSetToOnlyFriends(),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '3') ...[
              //
              userIsNoFriendAndProfileSetToOnlyMe(),
              //
            ],
          ] else if (arrHomePosts[i]['friendStatus'].toString() == '2') ...[
            // THEY BOTH ARE FRIENDS
            if (arrHomePosts[i]['SettingProfilePicture'].toString() == '1') ...[
              //
              userIsYesFriendAndProfileSetToEveryone(i),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '2') ...[
              //
              userIsYesFriendAndProfileSetToOnlyFriends(i),
              //
            ] else if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                '3') ...[
              //
              userIsYesFriendAndProfileSetToOnlyMe(),
              //
            ],
          ],

          //

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print(
                        'name 2',
                      );
                    }
                    //
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(
                          strUserId: arrHomePosts[i]['userId'].toString(),
                        ),
                      ),
                    );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: arrHomePosts[i]['fullName'].toString(),
                      //
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: ' shared location',
                          style: TextStyle(
                            color: Color.fromRGBO(
                              131,
                              131,
                              131,
                              1,
                            ),
                            fontSize: 14.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        //
                        TextSpan(
                          text: '\n${timeago.format(
                            DateTime.parse(
                              arrHomePosts[i]['created'].toString(),
                            ),
                          )}',
                          style: const TextStyle(
                            color: Color.fromRGBO(
                              210,
                              210,
                              210,
                              1,
                            ),
                            fontSize: 12.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //
          (widget.strFetchUserId.toString() ==
                  arrHomePosts[i]['userId'].toString())
              ? IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('open action sheet');
                    }
                    //
                    deletePostFromMenu(
                      context,
                      arrHomePosts[i]['postId'].toString(),
                    );
                    //
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('open action sheet');
                    }
                    //
                    // reportPostFromMenu(
                    //   context,
                    //   arrHomePosts[i]['postId'].toString(),
                    // );
                    blockUserPostFromMenu(
                        context, arrHomePosts[i]['postId'].toString());
                    //
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                )
          //
        ],
      ),
      // child: widget
    );
  }

  Container userIsNoFriendAndProfileSetToOnlyMe() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Container userIsYesFriendAndProfileSetToEveryone(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container userIsYesFriendAndProfileSetToOnlyFriends(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container userIsYesFriendAndProfileSetToOnlyMe() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Container userIsNoFriendAndProfileSetToOnlyFriends() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Container userIsNoFriendAndProfileSetToEveryone(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container textSharedContentUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(),
                ),
                height: 70,
                child: Row(
                  children: [
                    if (widget.strFetchUserId ==
                        arrHomePosts[i]['userId'].toString()) ...[
                      //
                      matchImageUserLoginProfilematched(i),
                      //
                    ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                            '0' ||
                        arrHomePosts[i]['friendStatus'].toString() == '1') ...[
                      // 0 = no friend
                      if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                          '1') ...[
                        //
                        userIsNoFriendAndProfileSetToEveryone(i),
                        //
                      ] else if (arrHomePosts[i]['SettingProfilePicture']
                              .toString() ==
                          '2') ...[
                        //
                        userIsNoFriendAndProfileSetToOnlyFriends(),
                        //
                      ] else if (arrHomePosts[i]['SettingProfilePicture']
                              .toString() ==
                          '3') ...[
                        //
                        userIsNoFriendAndProfileSetToOnlyMe(),
                        //
                      ],
                    ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                        '2') ...[
                      // THEY BOTH ARE FRIENDS
                      if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                          '1') ...[
                        //
                        userIsYesFriendAndProfileSetToEveryone(i),
                        //
                      ] else if (arrHomePosts[i]['SettingProfilePicture']
                              .toString() ==
                          '2') ...[
                        //
                        userIsYesFriendAndProfileSetToOnlyFriends(i),
                        //
                      ] else if (arrHomePosts[i]['SettingProfilePicture']
                              .toString() ==
                          '3') ...[
                        //
                        userIsYesFriendAndProfileSetToOnlyMe(),
                        //
                      ],
                    ],

                    //

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print(
                                  'name 2',
                                );
                              }
                              //
                              //
                              /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyProfileScreen(
                                              strUserId:
                                                  arrHomePosts[i]['userId'].toString(),
                                            ),
                                          ),
                                        );*/
                              //
                            },
                            child: RichText(
                              text: TextSpan(
                                //
                                text: arrHomePosts[i]['fullName'].toString(),
                                //
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: ' shared message',
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                        131,
                                        131,
                                        131,
                                        1,
                                      ),
                                      fontSize: 14.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //
                                  TextSpan(
                                    text: '\n${timeago.format(
                                      DateTime.parse(
                                        arrHomePosts[i]['created'].toString(),
                                      ),
                                    )}',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(
                                        210,
                                        210,
                                        210,
                                        1,
                                      ),
                                      fontSize: 12.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //

                    (widget.strFetchUserId.toString() ==
                            arrHomePosts[i]['userId'].toString())
                        ? IconButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print('open action sheet');
                              }
                              //
                              deletePostFromMenu(
                                context,
                                arrHomePosts[i]['postId'].toString(),
                              );
                              //
                            },
                            icon: const Icon(
                              Icons.menu,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print('open action sheet');
                              }
                              //
                              blockUserPostFromMenu(context,
                                  arrHomePosts[i]['postId'].toString());
                              //
                            },
                            icon: const Icon(
                              Icons.menu,
                            ),
                          ),
                    //
                  ],
                ),
              ),
              //
              Container(
                margin: const EdgeInsets.only(
                  left: 50.0,
                  top: 0.0,
                  bottom: 10.0,
                  right: 10.0,
                ),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                // height: 220,
                child: ReadMoreText(
                  //
                  arrHomePosts[i]['message'].toString(),
                  // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                  //
                  trimLines: 4,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: '...Show less',
                  moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //
            ],
          ),

          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              color: Colors.white,
              border: Border.all(width: 0.4),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 188, 182, 182),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(),
                  ),
                  height: 70,
                  child: Row(
                    children: [
                      /*if (widget.strFetchUserId ==
                          arrHomePosts[i]['userId'].toString()) ...[
                        //
                        matchImageUserLoginProfilematchedSHARE(i),
                        //
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                              '0' ||
                          arrHomePosts[i]['friendStatus'].toString() ==
                              '1') ...[
                        // 0 = no friend
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsNoFriendAndProfileSetToEveryoneSHARE(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyFriendsSHARE(),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyMeSHARE(),
                          //
                        ],
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                          '2') ...[
                        // THEY BOTH ARE FRIENDS
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsYesFriendAndProfileSetToEveryoneSHARE(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyFriendsSHARE(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyMeSHARE(),
                          //
                        ],
                      ],*/
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          image: (arrHomePosts[i]['share']['userImage']
                                      .toString() ==
                                  '')
                              ? const DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/avatar.png',
                                  ),
                                  fit: BoxFit.fitHeight,
                                )
                              : DecorationImage(
                                  image: NetworkImage(
                                    arrHomePosts[i]['share']['userImage']
                                        .toString(),
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      ),
                      //

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                if (kDebugMode) {
                                  print(
                                    'name 2',
                                  );
                                }
                                //
                                //
                                /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyProfileScreen(
                                                strUserId:
                                                    arrHomePosts[i]['userId'].toString(),
                                              ),
                                            ),
                                          );*/
                                //
                              },
                              child: RichText(
                                text: TextSpan(
                                  //
                                  text: arrHomePosts[i]['share']['userName']
                                      .toString(),
                                  //
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    (arrHomePosts[i]['share']['message'][0] ==
                                            '!')
                                        ? const TextSpan(
                                            text: ' shared location',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                131,
                                                131,
                                                131,
                                                1,
                                              ),
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const TextSpan(
                                            text: ' shared text',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                131,
                                                131,
                                                131,
                                                1,
                                              ),
                                              fontSize: 14.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    //
                                    TextSpan(
                                      text: '\n${timeago.format(
                                        DateTime.parse(
                                          arrHomePosts[i]['created'].toString(),
                                        ),
                                      )}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(
                                          210,
                                          210,
                                          210,
                                          1,
                                        ),
                                        fontSize: 12.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                if (arrHomePosts[i]['share']['message'][0] == '!') ...[
                  HomeFeedSharedLocationScreen(getData: arrHomePosts[i])
                ] else ...[
                  Container(
                    margin: const EdgeInsets.only(
                      left: 80.0,
                      top: 0.0,
                      bottom: 20.0,
                      right: 10.0,
                    ),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    // height: 220,
                    child: ReadMoreText(
                      //
                      arrHomePosts[i]['share']['message'].toString(),
                      // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a bdishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                      //
                      trimLines: 4,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '...Show more',
                      trimExpandedText: '...Show less',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]

                /**/
                //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container matchImageUserLoginProfilematchedSHARE(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['share']['userImage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container userIsNoFriendAndProfileSetToEveryoneSHARE(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['share']['userImage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container matchImageUserLoginProfilematched(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container videoUserHeaderFormat(BuildContext context, int i) {
    return Container(
      // height: 350,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    image: (arrHomePosts[i]['Userimage'].toString() == '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              arrHomePosts[i]['Userimage'].toString(),
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                ),

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: arrHomePosts[i]['fullName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text: ' shared some video',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n46 min ago',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                (widget.strFetchUserId.toString() ==
                        arrHomePosts[i]['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          deletePostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // print(arrHomePosts[i]);
                          blockUserPostFromMenu(
                              context, arrHomePosts[i]['postId'].toString());
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      ),
              ],
            ),
            // child: widget
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 50.0,
              top: 0.0,
              bottom: 10.0,
              right: 10.0,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 220,
            child: ReadMoreText(
              //
              arrHomePosts[i]['message'].toString(),
              // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
              //
              trimLines: 4,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Show more',
              trimExpandedText: '...Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Container deletePostWB(BuildContext context, int i) {
    return Container(
      // height: 350,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                if (strRealLoginUserId ==
                    arrHomePosts[i]['userId'].toString()) ...[
                  //
                  matchImageUserLoginProfilematched(i),
                  //
                ] else if (arrHomePosts[i]['friendStatus'].toString() == '0' ||
                    arrHomePosts[i]['friendStatus'].toString() == '1') ...[
                  // 0 = no friend
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                      '1') ...[
                    //
                    userIsNoFriendAndProfileSetToEveryone(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                    '2') ...[
                  // THEY BOTH ARE FRIENDS
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                      '1') ...[
                    //
                    userIsYesFriendAndProfileSetToEveryone(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyFriends(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ],
                // Container(
                //   margin: const EdgeInsets.only(left: 10.0),
                //   width: 60,
                //   height: 60,
                //   decoration: BoxDecoration(
                //     color: Colors.transparent,
                //     borderRadius: BorderRadius.circular(
                //       30,
                //     ),
                //     image: (arrHomePosts[i]['Userimage'].toString() == '')
                //         ? const DecorationImage(
                //             image: AssetImage(
                //               'assets/icons/avatar.png',
                //             ),
                //             fit: BoxFit.fitHeight,
                //           )
                //         : DecorationImage(
                //             image: NetworkImage(
                //               arrHomePosts[i]['Userimage'].toString(),
                //             ),
                //             fit: BoxFit.fitHeight,
                //           ),
                //   ),
                // ),

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: arrHomePosts[i]['fullName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                text: ' shared some image',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n${timeago.format(
                                  DateTime.parse(
                                    arrHomePosts[i]['created'].toString(),
                                  ),
                                )}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                (widget.strFetchUserId.toString() ==
                        arrHomePosts[i]['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          deletePostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet2');
                            print(arrHomePosts[i]);
                          }
                          //
                          // print(arrHomePosts[i]);
                          blockUserPostFromMenu(
                              context, arrHomePosts[i]['postId'].toString());
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      ),
              ],
            ),
            // child: widget
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 50.0,
              top: 0.0,
              bottom: 10.0,
              right: 10.0,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 220,
            child: ReadMoreText(
              //
              arrHomePosts[i]['message'].toString(),
              // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
              //
              trimLines: 4,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Show more',
              trimExpandedText: '...Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Container sharedTextDataUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      // height: 20,
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            // margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    image: (arrHomePosts[i]['Userimage'].toString() == '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              arrHomePosts[i]['Userimage'].toString(),
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                ),

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: arrHomePosts[i]['fullName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text: ' shared some message',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n46 min ago',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                (widget.strFetchUserId.toString() ==
                        arrHomePosts[i]['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          /*deletePostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );*/
                          blockUserPostFromMenu(
                              context, arrHomePosts[i]['postId'].toString());
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
              ],
            ),
            // child: widget
          ),
          //
          // MESSAGE NOT IN SHARED BOX
          //
          if (arrHomePosts[i]['message'].toString() != '') ...[
            Container(
              margin: const EdgeInsets.only(
                left: 50.0,
                top: 10.0,
                bottom: 10.0,
                right: 10.0,
              ),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              // height: 220,
              child: ReadMoreText(
                //
                arrHomePosts[i]['message'].toString(),
                // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                //
                trimLines: 4,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...Show more',
                trimExpandedText: '...Show less',
                moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          //
          Container(
            margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            // height: 20,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.transparent,
            ),
            child: Container(
              // height: 350,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // print(arrHomePosts[i]['share']);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                              image: (arrHomePosts[i]['share']['userImage']
                                          .toString() ==
                                      '')
                                  ? const DecorationImage(
                                      image: AssetImage(
                                        'assets/icons/avatar.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(
                                        arrHomePosts[i]['share']['userImage']
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        //

                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  if (kDebugMode) {
                                    print(
                                      'name 2',
                                    );
                                  }
                                  //
                                  //
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyProfileScreen(
                                        strUserId: arrHomePosts[i]['userId']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                  //
                                },
                                child: RichText(
                                  text: TextSpan(
                                    //
                                    text: arrHomePosts[i]['share']['userName']
                                        .toString(),
                                    //
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: ' shared some message',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            131,
                                            131,
                                            131,
                                            1,
                                          ),
                                          fontSize: 14.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //
                                      TextSpan(
                                        text: '\n46 min ago',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            210,
                                            210,
                                            210,
                                            1,
                                          ),
                                          fontSize: 12.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                    // child: widget
                  ),

                  Container(
                    margin: const EdgeInsets.only(
                      left: 50.0,
                      top: 0.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    // height: 220,
                    child: ReadMoreText(
                      //
                      arrHomePosts[i]['share']['message'].toString(),
                      // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                      //
                      trimLines: 4,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '...Show more',
                      trimExpandedText: '...Show less',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(
          //     left: 50.0,
          //     top: 0.0,
          //     bottom: 10.0,
          //     right: 10.0,
          //   ),
          //   color: Colors.transparent,
          //   width: MediaQuery.of(context).size.width,
          //   // height: 220,
          //   child: ReadMoreText(
          //     //
          //     arrHomePosts[i]['message'].toString(),
          //     // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
          //     //
          //     trimLines: 4,
          //     colorClickableText: Colors.pink,
          //     trimMode: TrimMode.Line,
          //     trimCollapsedText: '...Show more',
          //     trimExpandedText: '...Show less',
          //     moreStyle: const TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          //
        ],
      ),
    );
  }

  Container textDataIsNormalUI(BuildContext context, int i) {
    return Container(
      // height: 350,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // print(arrHomePosts[i]['share']);
                  },
                  child: Column(
                    children: [
                      if (strRealLoginUserId ==
                          arrHomePosts[i]['userId'].toString()) ...[
                        //
                        matchImageUserLoginProfilematched(i),
                        //
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                              '0' ||
                          arrHomePosts[i]['friendStatus'].toString() ==
                              '1') ...[
                        // 0 = no friend
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsNoFriendAndProfileSetToEveryone(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyFriends(),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsNoFriendAndProfileSetToOnlyMe(),
                          //
                        ],
                      ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                          '2') ...[
                        // THEY BOTH ARE FRIENDS
                        if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '1') ...[
                          //
                          userIsYesFriendAndProfileSetToEveryone(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '2') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyFriends(i),
                          //
                        ] else if (arrHomePosts[i]['SettingProfilePicture']
                                .toString() ==
                            '3') ...[
                          //
                          userIsYesFriendAndProfileSetToOnlyMe(),
                          //
                        ],
                      ],
                    ],
                  ),
                ),

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: arrHomePosts[i]['fullName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text: ' shared some message',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n46 min ago',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                (widget.strFetchUserId.toString() ==
                        arrHomePosts[i]['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          deletePostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // reportPostFromMenu(
                          //   context,
                          //   arrHomePosts[i]['postId'].toString(),
                          // );
                          blockUserPostFromMenu(
                              context, arrHomePosts[i]['postId'].toString());

                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
              ],
            ),
            // child: widget
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 50.0,
              top: 0.0,
              bottom: 10.0,
              right: 10.0,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 220,
            child: ReadMoreText(
              //
              arrHomePosts[i]['message'].toString(),
              // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
              //
              trimLines: 4,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Show more',
              trimExpandedText: '...Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  //
  funcPlayVideo(videoURL) {
    _controller2 = VideoPlayerController.network(
      videoURL,
    );

    _initializeVideoPlayerFuture2 = _controller2.initialize();
    // _controller2.play();
    setState(() {
      strListVideoPlay = '1';
    });
  }
  //

  Container likePostStructureUI(BuildContext context, int i) {
    return Container(
      // margin: const EdgeInsets.all(10.0),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('like click 2');
                        print(arrHomePosts[i]['youliked'].toString());
                        print(arrHomePosts[i]['postId'].toString());
                      }
                      //

                      strLikePress = '1';
                      //
                      QuickAlert.show(
                        context: context,
                        barrierDismissible: false,
                        type: QuickAlertType.loading,
                        title: 'Please wait...',
                        text: '',
                        onConfirmBtnTap: () {
                          if (kDebugMode) {
                            print('some click');
                          }
                          //
                        },
                      );
                      //

                      (arrHomePosts[i]['youliked'].toString() == 'No')
                          ? homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  });
                    },
                    icon: (arrHomePosts[i]['youliked'].toString() == 'No')
                        ? const Icon(
                            Icons.favorite_border,
                            size: 28,
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                  ),
                  //
                  textWithRegularStyle(
                    'like',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
          Expanded(
            child: InkWell(
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeFeedsCommentsScreen(
                      getDataForComment: arrHomePosts[i],
                    ),
                  ),
                );
                //
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 0.0,
                  left: 8,
                  bottom: 8,
                ),
                color: Colors.transparent,
                width: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('object');
                        }
                      },
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        size: 28,
                      ),
                    ),
                    //
                    textWithRegularStyle(
                      'comment',
                      Colors.black,
                      14.0,
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                right: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('object');
                      }
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 28,
                    ),
                  ),
                  //
                  textWithRegularStyle(
                    'share',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

//
  void blockUserPostFromMenu(
    BuildContext context,
    String strGetBlockFriend,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              blockUserWB(
                strGetBlockFriend,
              );
            },
            child: textWithRegularStyle(
              'Report',
              Colors.red,
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
              Colors.black,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  blockUserWB(
    strGetFriendIdIs,
  ) async {
    //

    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'reporting...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    if (kDebugMode) {
      print('=====> POST : USER CLICK REPORT POST ');
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
          'userId': widget.strFetchUserId.toString(),
          'postId': strGetFriendIdIs.toString(),
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
        arrHomePosts.clear();
        //
        hidePopup = '1';
        //
        //
        funcSendUserIdToGetHomeData(
          widget.strFetchUserId,
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

  void deletePostFromMenu(
    BuildContext context,
    String strGetPostId,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              deletePostFromServer(
                strGetPostId.toString(),
              );
              //
            },
            child: textWithRegularStyle(
              'Delete',
              Colors.red,
              14.0,
            ),
          ),
          /*CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //
              selectImages();
              //
              // ignore: deprecated_member_use
              /*PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('object');
                  }
                  // when user select photo from gallery
                  strPostType = '2';
                  // hide send button for text
                  strTextCount = '0';
                  //
                  imageFile = File(pickedFile.path);
                });
              }*/
            },
            child: textWithRegularStyle(
              'Open Gallery',
              Colors.black,
              14.0,
            ),
          ),*/
          // CupertinoActionSheetAction(
          //   onPressed: () async {
          //     Navigator.pop(context);

          //     //
          //   },
          //   child: textWithRegularStyle(
          //     'Block User',
          //     Colors.black,
          //     14.0,
          //   ),
          // ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.black,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  deletePostFromServer(
    String postId,
  ) async {
    //
    // s
    //
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.loading,
      title: 'Please wait...',
      text: 'deleting...',
      onConfirmBtnTap: () {
        if (kDebugMode) {
          print('some click');
        }
        //
      },
    );
    //
    //
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
          'userId': widget.strFetchUserId.toString(),
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
        //
        funcSendUserIdToGetHomeData(
          widget.strFetchUserId,
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
  func(videoURL) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 10,
    );
    return fileName;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  Container userIsNoFriendAndProfileSetToEveryoneSHAREImage(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
  Container matchImageUserLoginProfilematchedSHARE_image(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['Userimage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //s
  Container userIsYesFriendAndProfileSetToOnlyMeSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  //
  Container userIsNoFriendAndProfileSetToOnlyFriendsSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  //
  Container userIsNoFriendAndProfileSetToOnlyMeSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/icons/avatar.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  //s
  Container userIsYesFriendAndProfileSetToEveryoneSHARE(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['share']['userImage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
  Container userIsYesFriendAndProfileSetToOnlyFriendsSHARE(int i) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (arrHomePosts[i]['share']['userImage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  arrHomePosts[i]['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }
  //

  Future<Object?> videoPlayPopUPUI(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print('object');
                  }

                  setState(() {
                    if (strListVideoPlay == '0') {
                      strListVideoPlay = '1';
                      _controller2.pause();
                    } else {
                      strListVideoPlay = '0';
                      _controller2.play();
                    }
                  });
                  if (kDebugMode) {
                    print(strListVideoPlay);
                  }
                },
                child: FutureBuilder(
                    future: _initializeVideoPlayerFuture2,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _controller2.value.aspectRatio,
                          // width: MediaQuery.of(context)
                          // .size
                          // .width -
                          // 10,
                          //  height:
                          // 360,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              //
                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   color: Colors.amber,
                              // ),
                              VideoPlayer(
                                _controller2,
                              ),
                              //
                              (strListVideoPlay == '1')
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                24.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        //
                                        Container(
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
                                        //
                                        Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                24.0,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 10,
                                    )
                            ],
                          ),
                        );
                      } else {
                        // If the VideoPlayerController is still initializing, show a
                        // loading spinner.
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              );
            },
          );
        });
  }

  //
  Container videoSharedContentUI(BuildContext context, int i) {
    return Container(
      // height: 350,
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                if (widget.strFetchUserId ==
                    arrHomePosts[i]['userId'].toString()) ...[
                  //
                  matchImageUserLoginProfilematched(i),
                  //
                ] else if (arrHomePosts[i]['friendStatus'].toString() == '0' ||
                    arrHomePosts[i]['friendStatus'].toString() == '1') ...[
                  // 0 = no friend
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                      '1') ...[
                    //
                    userIsNoFriendAndProfileSetToEveryone(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ] else if (arrHomePosts[i]['friendStatus'].toString() ==
                    '2') ...[
                  // THEY BOTH ARE FRIENDS
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
                      '1') ...[
                    //
                    userIsYesFriendAndProfileSetToEveryone(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyFriends(i),
                    //
                  ] else if (arrHomePosts[i]['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ],

                //

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                              'name 2',
                            );
                          }
                          //
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: arrHomePosts[i]['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: arrHomePosts[i]['fullName'].toString(),
                            //
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                text: ' shared video',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                    131,
                                    131,
                                    131,
                                    1,
                                  ),
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                              TextSpan(
                                text: '\n${timeago.format(
                                  DateTime.parse(
                                    arrHomePosts[i]['created'].toString(),
                                  ),
                                )}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(
                                    210,
                                    210,
                                    210,
                                    1,
                                  ),
                                  fontSize: 12.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                (widget.strFetchUserId.toString() ==
                        arrHomePosts[i]['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          deletePostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet 4');
                            print(arrHomePosts[i]);
                          }
                          //
                          // print(arrHomePosts[i]);
                          blockUserPostFromMenu(
                              context, arrHomePosts[i]['postId'].toString());
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      ),
              ],
            ),
            // child: widget
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 50.0,
              top: 0.0,
              bottom: 10.0,
              right: 10.0,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 220,
            child: ReadMoreText(
              //
              arrHomePosts[i]['message'].toString(),
              // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
              //
              trimLines: 4,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Show more',
              trimExpandedText: '...Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          image: (arrHomePosts[i]['share']['userImage']
                                      .toString() ==
                                  '')
                              ? const DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/avatar.png',
                                  ),
                                  fit: BoxFit.fitHeight,
                                )
                              : DecorationImage(
                                  image: NetworkImage(
                                    arrHomePosts[i]['share']['userImage']
                                        .toString(),
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      ),

                      //

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                if (kDebugMode) {
                                  print(
                                    'name 2',
                                  );
                                }
                                //
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfileScreen(
                                      strUserId:
                                          arrHomePosts[i]['userId'].toString(),
                                    ),
                                  ),
                                );
                                //
                              },
                              child: RichText(
                                text: TextSpan(
                                  //
                                  text: arrHomePosts[i]['share']['userName']
                                      .toString(),
                                  //
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: ' shared video',
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                          131,
                                          131,
                                          131,
                                          1,
                                        ),
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //
                                    TextSpan(
                                      text: '\n${timeago.format(
                                        DateTime.parse(
                                          arrHomePosts[i]['created'].toString(),
                                        ),
                                      )}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(
                                          210,
                                          210,
                                          210,
                                          1,
                                        ),
                                        fontSize: 12.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                  // child: widget
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 50.0,
                    top: 0.0,
                    bottom: 10.0,
                    right: 10.0,
                  ),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  // height: 220,
                  child: ReadMoreText(
                    //
                    arrHomePosts[i]['share']['message'].toString(),
                    // 'dishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput idishant rajput is a boy dishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boydishant rajput is a boy',
                    //
                    trimLines: 4,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Show more',
                    trimExpandedText: '...Show less',
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (kDebugMode) {
                        // print(arrHomePosts[i]['postImage']);
                      }

                      funcPlayVideo(
                          arrHomePosts[i]['share']['postImage'][0]['name']);
                      // _controller2.play();
                      //
                      /*
                                  */
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black87,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return GestureDetector(
                                  onTap: () {
                                    if (kDebugMode) {
                                      print('object');
                                    }

                                    setState(() {
                                      if (strListVideoPlay == '0') {
                                        strListVideoPlay = '1';
                                        _controller2.pause();
                                      } else {
                                        strListVideoPlay = '0';
                                        _controller2.play();
                                      }
                                    });
                                    if (kDebugMode) {
                                      print(strListVideoPlay);
                                    }
                                  },
                                  child: FutureBuilder(
                                      future: _initializeVideoPlayerFuture2,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return AspectRatio(
                                            aspectRatio:
                                                _controller2.value.aspectRatio,
                                            // width: MediaQuery.of(context)
                                            // .size
                                            // .width -
                                            // 10,
                                            //  height:
                                            // 360,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                //
                                                // Container(
                                                //   height: 40,
                                                //   width: 40,
                                                //   color: Colors.amber,
                                                // ),
                                                VideoPlayer(
                                                  _controller2,
                                                ),
                                                //
                                                (strListVideoPlay == '1')
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  24.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            width: 48.0,
                                                            height: 48.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                24.0,
                                                              ),
                                                            ),
                                                            child: const Icon(
                                                              Icons.play_arrow,
                                                            ),
                                                          ),
                                                          //
                                                          Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  24.0,
                                                                ),
                                                              ),
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.cancel,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(
                                                        height: 10,
                                                      )
                                              ],
                                            ),
                                          );
                                        } else {
                                          // If the VideoPlayerController is still initializing, show a
                                          // loading spinner.
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                );
                              },
                            );
                          });
                    },
                    child: FutureBuilder(
                        future: func(
                          arrHomePosts[i]['share']['postImage'][0]['name']
                              .toString(),
                        ),
                        builder: (context, snapshot) {
                          // f (snapshot.connectionState ==
                          // ConnectionState.done) {
                          return Container(
                            // margin: const EdgeInsets.all(10.0),
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            height: 240,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                //
                                Container(
                                  // margin: const EdgeInsets.all(10.0),
                                  color: Colors.purple,
                                  width: MediaQuery.of(context).size.width,
                                  height: 220,
                                  child: (snapshot.data == null)
                                      ? Image.asset(
                                          'assets/icons/avatar.png',
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
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      )
                              ],
                              // child:
                            ),
                          );
                          /*Stack(
                                      // fit: StackFit.expand,
                                      children: [
                                        Container(
                                          // margin: const EdgeInsets.all(10.0),
                                          color: Colors.purple,
                                          width: MediaQuery.of(context).size.width,
                                          height: 220,
                                          child: Image.file(
                                            File(
                                              snapshot.data.toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        //
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            color: Colors.amber,
                                            height: 40,
                                            width: 40,
                                            child: const Icon(
                                              Icons.play_arrow,
                                            ),
                                          ),
                                        )
                                      ],
                                    );*/
                          // }
                          /*else {
                                    // If the VideoPlayerController is still initializing, show a
                                    // loading spinner.
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }*/
                        }),
                  ),
                ),
              ],
            ),
          ),
          //
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //
  Container videoSharedContentLikeCommentShareUI(BuildContext context, int i) {
    return Container(
      // margin: const EdgeInsets.all(10.0),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('like click 2');
                        print(arrHomePosts[i]['youliked'].toString());
                        print(arrHomePosts[i]['postId'].toString());
                      }
                      //

                      strLikePress = '1';
                      //
                      QuickAlert.show(
                        context: context,
                        barrierDismissible: false,
                        type: QuickAlertType.loading,
                        title: 'Please wait...',
                        text: '',
                        onConfirmBtnTap: () {
                          if (kDebugMode) {
                            print('some click');
                          }
                          //
                        },
                      );
                      //

                      (arrHomePosts[i]['youliked'].toString() == 'No')
                          ? homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                widget.strFetchUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      widget.strFetchUserId.toString(),
                                    ),
                                  });
                    },
                    icon: (arrHomePosts[i]['youliked'].toString() == 'No')
                        ? const Icon(
                            Icons.favorite_border,
                            size: 28,
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                  ),
                  //
                  textWithRegularStyle(
                    '${arrHomePosts[i]['likesCount'].toString()} like',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
          Expanded(
            child: InkWell(
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeFeedsCommentsScreen(
                      getDataForComment: arrHomePosts[i],
                    ),
                  ),
                );
                //
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 0.0,
                  left: 8,
                  bottom: 8,
                ),
                color: Colors.transparent,
                // width: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('object');
                        }
                      },
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        size: 24,
                      ),
                    ),
                    //
                    textWithRegularStyle(
                      'comment',
                      Colors.black,
                      12.0,
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 0.0,
                left: 8,
                right: 8,
                bottom: 8,
              ),
              color: Colors.transparent,
              width: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('share click video');
                      }

                      // setState(() {
                      //   // print('object1');
                      //   contWriteSomething.text = '';
                      //   strPostType = '7';
                      //   strTextCount = '0';
                      //   sharedPostType = 'Video';
                      //   //
                      //   sharedDataStored = arrHomePosts[i];
                      //   //
                      // });
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 28,
                    ),
                  ),
                  //
                  textWithRegularStyle(
                    'share',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  //
  _onMapCreated() {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        strUserLat,
        strUserLong,
      ),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: 'qwer',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
  //
}
