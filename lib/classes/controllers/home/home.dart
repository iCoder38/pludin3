// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:get/get.dart';
// import 'package:pludin/classes/controllers/custom_app_bar/custom_app_bar.dart';
import 'package:pludin/classes/controllers/database/database_helper.dart';
import 'package:pludin/classes/controllers/drawer/drawer.dart';
import 'package:pludin/classes/controllers/home/home_feeds_comment/home_feeds_comments.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_image_UI/home_feeds_image_UI.dart';
// import 'package:pludin/classes/controllers/home/home_feeds_text_UI/home_feeds_text_UI.dart';
import 'package:pludin/classes/controllers/home/home_like_modal/home_like_modal.dart';
import 'package:pludin/classes/controllers/home/home_modal/home_modal.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
// import 'package:pludin/classes/custom/app_bar.dart';
import 'package:pludin/classes/header/utils.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neopop/neopop.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../profile/profile_gallery/profile_gallery.dart';
import 'home_feeds_for_location/home_feeds_for_location.dart';

import 'package:path_provider/path_provider.dart';

import 'home_feeds_shared_location/home_feed_shared_location.dart';

import 'package:timeago/timeago.dart' as timeago;

/*
Myself Dishant Rajput. Mobile app Developer ( iOS Developer ) 2 years of experience. 
 */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  /*static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);*/

//
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  //
  var strDeleteScreenLoader = '1';
  //
  var strPlayPause = '0';
  final homeLikeUnlikeApiCall = HomeLikeModal();
  //
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  //
  VideoPlayerController? _controller2;
  late Future<void> _initializeVideoPlayerFuture2;
  //
  // late VideoPlayerController _listController;
  // late Future<void> _listInitializeVideoPlayerFuture;
  //
  var strLikePress = '0';
  var strPostType = '1';
  var strTextCount = '0';
  //
  var strUserSelectImage = '0';
  var strHomeloader = '0';
  var strLoginUserImage = '';
  var strGetUserId = '';
  var arrHomePosts = [];
  //
  late DataBase handler;
  //
  final homeApiCall = HomeModal();
  //
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //
  File? thumbNailImageFile;
  File? imageFile;
  ImagePicker picker = ImagePicker();
  // multiples
  var strGridCount = 0;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  //
  late final TextEditingController contWriteSomething;
  //
  var strListVideoPlay = '0';
  //
  var strImageCount = 0;
  //
  late int currentIndex;
  //
  List<String> arr_scroll_multiple_images = [];
  var sharedPostType = '0';
  var sharedDataStored;
  //
  int pageControl = 1;
  var strShowFloatingActionButton = '0';
  var shouldShow = '0';
//
  @override
  void initState() {
    super.initState();
    //
    contWriteSomething = TextEditingController();
    //
    handler = DataBase();
    //

    if (kDebugMode) {
      print('================= TIME =================');
      print(
        FirebaseAuth.instance.currentUser!.uid,
      );
      print(timeago.format(DateTime.parse("2023-06-21 12:28")));
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      print('DISHANT RAJPUT GET TIME FORMATT start');
      print(formattedDate);
      // I/flutter ( 7502): 2023-06-22 12:06:559
      print('DISHANT RAJPUT GET TIME FORMATT end');
    }
    //
    funcGetLocalDBdata();
    //
    /*funcGetLocalDBdata().then((value1) {
      
    });*/
    //
    funcGetUserLatAndLong();
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

// 7070022222
// re-kyc
//
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 3),
      curve: Curves.linear,
    );
  }

  func(videoURL) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video:
          videoURL, //"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return fileName;
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
  }

  @override
  void dispose() {
    //
    _controller?.dispose();
    _controller2?.dispose();
    // _listController.dispose();
    contWriteSomething.dispose();
    _scrollController.dispose(); // dispose the controller
    //
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
            print('YES, LOCAL DB HAVE SOME DATA');
          }
          //

          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    strGetUserId = value[i].userId.toString(),
                    strLoginUserImage = value[i].image.toString(),
                    // print(strLoginUserImage),
                    //
                  },
                //
                funcSendUserIdToGetHomeData(
                    strGetUserId.toString(), 'no', pageControl),
                //
              });
        }
      },
    );
    //
  }

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
      // if (kDebugMode) {}
      //
      // arrHomePosts.clear();
      //
      for (int i = 0; i < value1.length; i++) {
        arrHomePosts.add(value1[i]);
      }

      //
      if (strLikePress == '1') {
        Navigator.pop(context);
      }

      if (pageControl != 1) {
        Navigator.pop(context);
      }

      //

      /*print('Rajput 1 ======> $arrHomePosts');
      print('Rajput 2 ======> ${arrHomePosts.length}');
      print('Rajput 3 ======> ${arrHomePosts[0]['message']}');*/
      //print('object41414');
      setState(() {
        strHomeloader = '1';
        // strDeleteScreenLoader = '1';
        if (strBack == 'yes') {
          Navigator.pop(context);
        }
      });
    });
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
      ),
      floatingActionButton: (pageControl == 0)
          ? const SizedBox(
              height: 0,
            )
          : (shouldShow == '0')
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('fla');
                    }
                    //
                    _scrollToTop();
                    //
                  },
                  backgroundColor: navigationColor,
                  child: const Icon(
                    Icons.expand_less,
                  ),
                ),
      //     ],
      //   )
      // ],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const navigationDrawer(),
      ),
      body: (strDeleteScreenLoader == '0')
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (isTop) {
                    if (kDebugMode) {
                      print('At the top');
                    }
                    //
                    setState(() {
                      shouldShow = '0';
                    });
                    //
                  } else {
                    if (kDebugMode) {
                      print('At the bottom');
                    }
                    //
                    // setState(() {

                    // });
                    // setState(() {
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
                    pageControl += 1;
                    //
                    setState(() {
                      shouldShow = '1';
                    });

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
                controller: _scrollController,
                child: Column(
                  children: [
                    // custom app bar
                    /*CustomAppBarScreen(
                      strForMenu: '1',
                      getScaffold: scaffoldKey,
                      strTextOrImage: '0',
                    ),*/
                    //
                    writeSomethingUI(context),
                    //

                    for (int i = 0; i < arrHomePosts.length; i++) ...[
                      if (i == arrHomePosts.length) ...[
                        AlertDialog(
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
                      ],

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
                      if (strHomeloader == '0')
                        Center(
                          child: textWithRegularStyle(
                            'No data',
                            Colors.black,
                            22.0,
                          ),
                        )
                      else if (arrHomePosts[i]['postType'] == 'Image') ...[
                        // image

                        // if (arrHomePosts[i]['share'] == null)

                        if (arrHomePosts[i]['share'] == null) ...[
                          deletePostWB(context, 'image', i),
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

                                    GestureDetector(
                                      onTap: () {
                                        //
                                        arr_scroll_multiple_images.clear();
                                        //
                                        funcOpenImage(pagePosition, i);
                                        //
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        // height: 240,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: i == currentIndex
                                                ? Colors.white
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        // child:
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            24.0,
                                          ),
                                          child: Image.network(
                                            //
                                            arrHomePosts[i]['postImage']
                                                [pagePosition]['name'],
                                            //
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('like click 2');
                                              print(arrHomePosts[i]['youliked']
                                                  .toString());
                                              print(arrHomePosts[i]['postId']
                                                  .toString());
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

                                            (arrHomePosts[i]['youliked']
                                                        .toString() ==
                                                    'No')
                                                ? homeLikeUnlikeApiCall
                                                    .homeLikeUnlikeWB(
                                                      strGetUserId.toString(),
                                                      arrHomePosts[i]['postId']
                                                          .toString(),
                                                      '1',
                                                    )
                                                    .then((value) => {
                                                          funcSendUserIdToGetHomeData(
                                                            strGetUserId
                                                                .toString(),
                                                            'no',
                                                            pageControl,
                                                          ),
                                                        })
                                                : homeLikeUnlikeApiCall
                                                    .homeLikeUnlikeWB(
                                                      strGetUserId.toString(),
                                                      arrHomePosts[i]['postId']
                                                          .toString(),
                                                      '2',
                                                    )
                                                    .then((value) => {
                                                          funcSendUserIdToGetHomeData(
                                                            strGetUserId
                                                                .toString(),
                                                            'no',
                                                            pageControl,
                                                          ),
                                                        });
                                          },
                                          icon: (arrHomePosts[i]['youliked']
                                                      .toString() ==
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
                                          builder: (context) =>
                                              HomeFeedsCommentsScreen(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('share click image');
                                            }
                                            //
                                            setState(() {
                                              contWriteSomething.text = '';
                                              strPostType = '6';
                                              strTextCount = '0';
                                              //
                                              sharedPostType = 'Image';
                                              sharedDataStored =
                                                  arrHomePosts[i];
                                            });
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
                          deletePostWB(context, 'video', i),
                          //

                          InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print(arrHomePosts[i]['postImage']);
                              }

                              funcPlayVideo(
                                  arrHomePosts[i]['postImage'][0]['name']);
                              // _controller2.play();
                              //
                              /*
                          */
                              videoPlayPopUPUI(context);
                            },
                            child: FutureBuilder(
                              future: func(
                                arrHomePosts[i]['postImage'][0]['name']
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                width: 48.0,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('like click 2');
                                              print(arrHomePosts[i]['youliked']
                                                  .toString());
                                              print(arrHomePosts[i]['postId']
                                                  .toString());
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

                                            (arrHomePosts[i]['youliked']
                                                        .toString() ==
                                                    'No')
                                                ? homeLikeUnlikeApiCall
                                                    .homeLikeUnlikeWB(
                                                      strGetUserId.toString(),
                                                      arrHomePosts[i]['postId']
                                                          .toString(),
                                                      '1',
                                                    )
                                                    .then((value) => {
                                                          funcSendUserIdToGetHomeData(
                                                            strGetUserId
                                                                .toString(),
                                                            'no',
                                                            pageControl,
                                                          ),
                                                        })
                                                : homeLikeUnlikeApiCall
                                                    .homeLikeUnlikeWB(
                                                      strGetUserId.toString(),
                                                      arrHomePosts[i]['postId']
                                                          .toString(),
                                                      '2',
                                                    )
                                                    .then((value) => {
                                                          funcSendUserIdToGetHomeData(
                                                            strGetUserId
                                                                .toString(),
                                                            'no',
                                                            pageControl,
                                                          ),
                                                        });
                                          },
                                          icon: (arrHomePosts[i]['youliked']
                                                      .toString() ==
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
                                          builder: (context) =>
                                              HomeFeedsCommentsScreen(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('share click video');
                                            }

                                            setState(() {
                                              // print('object1');
                                              contWriteSomething.text = '';
                                              strPostType = '7';
                                              strTextCount = '0';
                                              sharedPostType = 'Video';
                                              //
                                              sharedDataStored =
                                                  arrHomePosts[i];
                                              //
                                            });
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
                        ]
                        // ]

                        //
                      ] else if (arrHomePosts[i]['postType'] == 'Text') ...[
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
                            sharedTextDataUI(context, i), // shared data
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
//

                    //
                  ],
                ),
              ),
            ),
    );
  }

  // NotificationListener homeFullScreenUI(BuildContext context) {
  //   return NotificationListener<ScrollNotification>(
  //     onNotification: (scrollNotification) {
  //       if (scrollNotification is ScrollStartNotification) {
  //         // _onStartScroll(scrollNotification.metrics);
  //         // print('object 3');
  //       } else if (scrollNotification is ScrollUpdateNotification) {
  //         // _onUpdateScroll(scrollNotification.metrics);
  //         // print('object 2');
  //       } else if (scrollNotification is ScrollEndNotification) {
  //         print('LAST INDEX OF CELL');
  //         // setState(() {
  //         //   // strRefreshLoader = 'refresh';
  //         //   //
  //         // });
  //         // _needsScroll = true;
  //         // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  //         // _onEndScroll(scrollNotification.metrics);
  //       }
  //       return true;
  //     },
  //     // child: ,
  //   );
  // }

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
                    arrHomePosts[i]['message'].toString(),
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

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // margin: const EdgeInsets.all(10.0),
                        color: Colors.pink[600],
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
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

  funcOpenImage(pagePosition, i) {
    // print(arrHomePosts);
    // print(arrHomePosts[i]);
    // print(arrHomePosts[i]);
    // print(arrHomePosts[i]['postImage']);
    // print(arrHomePosts[i]['postImage'].length);

    for (int j = 0; j < arrHomePosts[i]['postImage'].length; j++) {
      arr_scroll_multiple_images.add(arrHomePosts[i]['postImage'][j]['name']);
    }
    // print(arr_scroll_multiple_images);
    // print(arr_scroll_multiple_images.length);

    CustomImageProvider customImageProvider = CustomImageProvider(
        //
        imageUrls: arr_scroll_multiple_images.toList(),

        //
        initialIndex: pagePosition);
    showImageViewerPager(context, customImageProvider, doubleTapZoomable: true,
        onPageChanged: (page) {
      // print("Page changed to $page");
    }, onViewerDismissed: (page) {
      // print("Dismissed while on page $page");
    });
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
                      if (strGetUserId ==
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
                      (strGetUserId.toString() ==
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
                                reportPostFromMenu(
                                  context,
                                  arrHomePosts[i]['postId'].toString(),
                                );
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
          if (strGetUserId == arrHomePosts[i]['userId'].toString()) ...[
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

  Container locationNotSharedHeaderUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.all(10.0),

      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          if (strGetUserId == arrHomePosts[i]['userId'].toString()) ...[
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
          (strGetUserId.toString() == arrHomePosts[i]['userId'].toString())
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
                    reportPostFromMenu(
                      context,
                      arrHomePosts[i]['postId'].toString(),
                    );
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
                      _controller2?.pause();
                    } else {
                      strListVideoPlay = '0';
                      _controller2?.play();
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
                          aspectRatio: _controller2!.value.aspectRatio,
                          // width: MediaQuery.of(context)
                          // .size
                          // .width -
                          // 10,
                          //  height:
                          // 360,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              VideoPlayer(
                                _controller2!,
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
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
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

                      setState(() {
                        // print('object1');
                        contWriteSomething.text = '';
                        strPostType = '7';
                        strTextCount = '0';
                        sharedPostType = 'Video';
                        //
                        sharedDataStored = arrHomePosts[i];
                        //
                      });
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
                (strGetUserId.toString() ==
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
                            print('open action sheet 3');
                          }
                          //
                          // print(arrHomePosts[i]);
                          // blockUserPostFromMenu(context,
                          //     arrHomePosts[i]['userId'].toString());
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
                                        _controller2?.pause();
                                      } else {
                                        strListVideoPlay = '0';
                                        _controller2?.play();
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
                                                _controller2!.value.aspectRatio,
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
                                                  _controller2!,
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
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                  arrHomePosts[i]['Userimage'].toString(),
                                ),
                                fit: BoxFit.cover,
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

                    (strGetUserId.toString() ==
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
                              reportPostFromMenu(
                                context,
                                arrHomePosts[i]['postId'].toString(),
                              );
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
                      if (strGetUserId ==
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

  Container shardImageDataUI(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        left: 10.0,
        bottom: 10.0,
      ),
      // height: 350,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
        border: Border.all(),
        color: Colors.white,
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
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                if (strGetUserId == arrHomePosts[i]['userId'].toString()) ...[
                  //
                  matchImageUserLoginProfilematchedSHARE(i),
                  //
                ] else if (arrHomePosts[i]['friendStatus'].toString() == '0' ||
                    arrHomePosts[i]['friendStatus'].toString() == '1') ...[
                  // 0 = no friend
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
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
                  if (arrHomePosts[i]['SettingProfilePicture'].toString() ==
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
              border: Border.all(
                color: Colors.transparent,
              ),
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
                            color: Colors.transparent,
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
                if (strGetUserId == arrHomePosts[i]['userId'].toString()) ...[
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
                /*InkWell(
                  onTap: () {
                    // print(arrHomePosts[i]['share']);
                    if (kDebugMode) {
                      print('image click 1.0');
                    }
                  },
                  child: Container(
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
                ),*/

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
                (strGetUserId.toString() ==
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
                          reportPostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
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
                            children: <TextSpan>[
                              const TextSpan(
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
                (strGetUserId.toString() ==
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
                                    children: <TextSpan>[
                                      const TextSpan(
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
                                        text: '\n${timeago.format(
                                          DateTime.parse(
                                            arrHomePosts[i]['created']
                                                .toString(),
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
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
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

                      setState(() {
                        if (kDebugMode) {
                          print('======> USER SHARE LOCATION <======');
                        }
                        contWriteSomething.text = '';
                        strPostType = '8';
                        strTextCount = '0';
                        sharedPostType = 'Map';
                        //
                        sharedDataStored = arrHomePosts[i];
                        //
                      });
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
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
                                    ),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                arrHomePosts[i]['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                      strGetUserId.toString(),
                                      'no',
                                      pageControl,
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
                      if (arrHomePosts[i]['message'][0] == '!') {
                        setState(() {
                          if (kDebugMode) {
                            print('======> USER SHARE LOCATION <======');
                          }
                          contWriteSomething.text = '';
                          strPostType = '8';
                          strTextCount = '0';
                          sharedPostType = 'Text';
                          //
                          sharedDataStored = arrHomePosts[i];
                          //
                        });
                      } else {
                        setState(() {
                          if (kDebugMode) {
                            print('======> USER SHARE TEXT <======');
                          }
                          contWriteSomething.text = '';
                          strPostType = '8';
                          strTextCount = '0';
                          sharedPostType = 'Text';
                          //
                          sharedDataStored = arrHomePosts[i];
                          //
                        });
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

  Container deletePostWB(BuildContext context, String strTitle, int i) {
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
                if (strGetUserId == arrHomePosts[i]['userId'].toString()) ...[
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
                              TextSpan(
                                text: ' shared some $strTitle',
                                style: const TextStyle(
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
                (strGetUserId.toString() ==
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
                            print('open action sheet 2');
                          }
                          //
                          reportPostFromMenu(
                            context,
                            arrHomePosts[i]['postId'].toString(),
                          );
                          // print(arrHomePosts[i]);
                          // blockUserPostFromMenu(
                          // context, arrHomePosts[i]['userId'].toString());
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

  Container writeSomethingUI(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(10.0),
      color: const Color.fromARGB(255, 237, 235, 235), //[600],
      width: MediaQuery.of(context).size.width,
      // height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                (strLoginUserImage == '')
                    ? InkWell(
                        onTap: () {
                          //
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: strGetUserId,
                              ),
                            ),
                          );
                          //
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          width: 48,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              24.0,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/icons/avatar.png',
                              ),
                            ),
                          ),
                          /*
                                      strLoginUserImage */
                          // child: ,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          //
                          // print(strGetUserId);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: strGetUserId,
                              ),
                            ),
                          );
                          //
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: navigationColor,
                              width: 2,
                            ),
                          ),
                          child: Image.network(
                            //
                            strLoginUserImage,
                            //
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                        //
                        if (strPostType == '2') {
                          // yes user select some image from gallery
                          strTextCount = '0';
                          setState(() {});
                        } else {
                          //
                          setState(() {
                            if (value.isEmpty) {
                              strTextCount = '0';
                            } else {
                              strTextCount = '1';
                            }
                          });
                          //
                        }
                      },
                    ),
                  ),
                ),
                (strTextCount == '0')
                    ? const SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('object 2');
                          }
                          //
                          funcUploadDataWithOnlyText();
                          //
                        },
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                InkWell(
                  onTap: () {
                    //
                    openCameraAndGaleeryPopUP(context);
                    //
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    width: 48,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        0.0,
                      ),
                    ),
                    child: Image.asset(
                      'assets/icons/profile_image_black.png',
                      width: 300,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            //
            if (strPostType == '2') ...[
              // IMAGE
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
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: NeoPopButton(
                      color: Colors.white,
                      onTapUp: () {
                        //
                        // uploadImageWithOrWithoutText();
                        uploadMultipleImagesOnServer('Image');
                        //
                      },
                      onTapDown: () => HapticFeedback.vibrate(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWithBoldStyle(
                            'Upload',
                            Colors.green,
                            16.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  const SizedBox(
                    width: 20,
                  ),
                  //
                  Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: NeoPopButton(
                      color: Colors.white,
                      onTapUp: () => setState(() {
                        if (kDebugMode) {
                          print(contWriteSomething.text.length);
                        }
                        if (contWriteSomething.text.isEmpty) {
                          strTextCount = '0';
                        } else {
                          strTextCount = '1';
                        }
                        //
                        strPostType = '1';
                      }),
                      onTapDown: () => HapticFeedback.vibrate(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWithBoldStyle(
                            'Remove',
                            Colors.red,
                            14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ] else if (strPostType == '3') ...[
              // VIDEO

              InkWell(
                onTap: () {
                  if (kDebugMode) {
                    // print('object');
                  }
                  //
                  setState(() {
                    if (strPlayPause == '0') {
                      strPlayPause = '1';
                      //
                      _controller?.play();
                      //
                    } else {
                      strPlayPause = '0';
                      //
                      _controller?.pause();
                      //
                    }
                  });
                  //
                },
                child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the VideoPlayerController has finished initialization, use
                        // the data it provides to limit the aspect ratio of the video.
                        return Column(
                          children: [
                            Container(
                              // margin: const EdgeInsets.all(10.0),
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              height: 240,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  //
                                  VideoPlayer(_controller!),
                                  //
                                  (strPlayPause == '0')
                                      ? Center(
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: 48.0,
                                            height: 48.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(
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
                            ),
                            //
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ),
                                  ),
                                  child: NeoPopButton(
                                    color: Colors.white,
                                    onTapUp: () {
                                      //
                                      if (kDebugMode) {
                                        print('UPLOAD HIT FOR =====> VIDEO');
                                      }
                                      uploadMultipleImagesOnServer('Video');
                                      //
                                    },
                                    onTapDown: () => HapticFeedback.vibrate(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        textWithBoldStyle(
                                          'Upload',
                                          Colors.green,
                                          16.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //
                                const SizedBox(
                                  width: 20,
                                ),
                                //
                                Container(
                                  height: 40,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ),
                                  ),
                                  child: NeoPopButton(
                                    color: Colors.white,
                                    onTapUp: () => setState(() {
                                      if (kDebugMode) {
                                        print(contWriteSomething.text.length);
                                      }
                                      if (contWriteSomething.text.isEmpty) {
                                        strTextCount = '0';
                                      } else {
                                        strTextCount = '1';
                                      }
                                      //
                                      strPostType = '1';
                                    }),
                                    onTapDown: () => HapticFeedback.vibrate(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        textWithBoldStyle(
                                          'Remove',
                                          Colors.red,
                                          14.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //
                              ],
                            ),
                          ],
                        );
                      } else {
                        // If the VideoPlayerController is still initializing, show a
                        // loading spinner.
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ] else if (strPostType == '4') ...[
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.pink[600],
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          strUserLat,
                          strUserLong,
                        ),
                        zoom: 14.0,
                      ),
                      /*initialCameraPosition: CameraPosition(
                        target: LatLng(
                          28.7041,
                          77.1025,
                        ),
                        zoom: 11.0,
                        tilt: 0,
                        bearing: 0,
                      ),*/
                      markers: markers.values.toSet(),
                    ),
                  ),
                  //
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: NeoPopButton(
                          color: Colors.white,
                          onTapUp: () {
                            //
                            if (kDebugMode) {
                              print('send location to server');
                            }
                            if (kDebugMode) {
                              print(contWriteSomething.text);
                              print(strUserLat);
                              print(strUserLong);
                            }
                            //
                            // var createCustomMessageForLocation =
                            // '!@()$strUserLat!@()$strUserLong!@()${contWriteSomething.text}';
                            var createCustomMessageForLocation =
                                '$strUserLat,$strUserLong,${contWriteSomething.text}';
                            //

                            funcSendLocationToServer(
                                createCustomMessageForLocation);
                            //
                          },
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'Upload',
                                Colors.green,
                                16.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        width: 20,
                      ),
                      //
                      Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: NeoPopButton(
                          color: Colors.white,
                          onTapUp: () => setState(() {
                            if (kDebugMode) {
                              print(contWriteSomething.text.length);
                            }
                            if (contWriteSomething.text.isEmpty) {
                              strTextCount = '0';
                            } else {
                              strTextCount = '1';
                            }
                            //
                            strPostType = '1';
                          }),
                          onTapDown: () => HapticFeedback.vibrate(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWithBoldStyle(
                                'Remove',
                                Colors.red,
                                14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                  //
                ],
              ),
            ] else if (strPostType == '5') ...[
              //
              if (sharedDataStored['postType'] == 'Text') ...[
                //
                shareMethodUI(context),
                //
              ]
              //
            ] else if (strPostType == '6') ...[
              //
              if (sharedDataStored['postType'] == 'Image') ...[
                //
                sharedImageUI(context),
                //

                //
              ]
              //
            ] else if (strPostType == '8') ...[
              //
              if (sharedDataStored['postType'] == 'Text') ...[
                //
                shareMethodUI(context),
                //
              ] else ...[
                //
                locationShareBeforeUploadUI(context),
                //
              ]
            ] else if (strPostType == '7') ...[
              //
              if (sharedDataStored['postType'] == 'Video') ...[
                //
                // sharedImageUI(context),
                Container(
                  //margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  // height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 0, left: 10.0),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              image:
                                  (sharedDataStored['Userimage'].toString() ==
                                          '')
                                      ? const DecorationImage(
                                          image: AssetImage(
                                            'assets/icons/avatar.png',
                                          ),
                                          fit: BoxFit.fitHeight,
                                        )
                                      : DecorationImage(
                                          image: NetworkImage(
                                            sharedDataStored['Userimage']
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
                              // height: 100,
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
                                          strUserId: sharedDataStored['userId']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                    //
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      //
                                      text: sharedDataStored['fullName']
                                          .toString(),
                                      //
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
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
                                          text: '\n${timeago.format(
                                            DateTime.parse(
                                              sharedDataStored['created']
                                                  .toString(),
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
                          sharedDataStored['message'].toString(),
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
                      /*Container(
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
                          itemCount: sharedDataStored['postImage'].length,
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
                                      sharedDataStored['postImage']
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
                                        '$currentIndex / ${sharedDataStored['postImage'].length}',
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
                      ),*/
                      //
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
                      ///
                      if (sharedDataStored['postImage'].length == 0)
                        ...[]
                      else ...[
                        // deletePostWB(context, i),
                        //

                        InkWell(
                          onTap: () {
                            if (kDebugMode) {
                              // print(arrHomePosts[i]['postImage']);
                            }

                            funcPlayVideo(
                                sharedDataStored['postImage'][0]['name']);
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
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (kDebugMode) {
                                            print('object');
                                          }

                                          setState(() {
                                            if (strListVideoPlay == '0') {
                                              strListVideoPlay = '1';
                                              _controller2?.pause();
                                            } else {
                                              strListVideoPlay = '0';
                                              _controller2?.play();
                                            }
                                          });
                                          if (kDebugMode) {
                                            print(strListVideoPlay);
                                          }
                                        },
                                        child: FutureBuilder(
                                            future:
                                                _initializeVideoPlayerFuture2,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return AspectRatio(
                                                  aspectRatio: _controller2!
                                                      .value.aspectRatio,
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
                                                        _controller2!,
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
                                                                  child:
                                                                      Container(
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
                                                                              .all(
                                                                          10.0),
                                                                  width: 48.0,
                                                                  height: 48.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      24.0,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                  ),
                                                                ),
                                                                //
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        24.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .cancel,
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
                                                  child:
                                                      CircularProgressIndicator(),
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
                                sharedDataStored['postImage'][0]['name']
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                width: 48.0,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                        //
                      ],
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                            ),
                            child: NeoPopButton(
                              color: Colors.white,
                              onTapUp: () {
                                //
                                if (kDebugMode) {
                                  print('SHARED DATA FOR VIDEO');
                                }
                                funcShareDataWB(
                                    sharedDataStored['postId'].toString());
                                //
                              },
                              onTapDown: () => HapticFeedback.vibrate(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textWithBoldStyle(
                                    'Upload',
                                    Colors.green,
                                    16.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //
                          const SizedBox(
                            width: 20,
                          ),
                          //
                          Container(
                            height: 40,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                            ),
                            child: NeoPopButton(
                              color: Colors.white,
                              onTapUp: () => setState(() {
                                if (kDebugMode) {
                                  print(contWriteSomething.text.length);
                                }
                                if (contWriteSomething.text.isEmpty) {
                                  strTextCount = '0';
                                } else {
                                  strTextCount = '1';
                                }
                                //
                                strPostType = '1';
                              }),
                              onTapDown: () => HapticFeedback.vibrate(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textWithBoldStyle(
                                    'Remove',
                                    Colors.red,
                                    14.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //
                        ],
                      ),
                      //
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                //

                //
              ]
              //
            ] else if (strPostType == 'loader') ...[
              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                // height: 20.0,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ] else ...[
              const SizedBox(
                height: 0,
              ),
            ]
          ],
        ),
      ),
      // child: widget
    );
  }

  Container locationShareBeforeUploadUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
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
                    image: (sharedDataStored['Userimage'].toString() == '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              sharedDataStored['Userimage'].toString(),
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
                                    sharedDataStored['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: sharedDataStored['fullName'].toString(),
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
                                    sharedDataStored['created'].toString(),
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
                (strGetUserId.toString() ==
                        sharedDataStored['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          deletePostFromMenu(
                            context,
                            sharedDataStored['postId'].toString(),
                          );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                //
              ],
            ),
          ),
          //
          HomeFeedsForLocation(getData: sharedDataStored),
          //
          const SizedBox(
            height: 10,
          ),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: NeoPopButton(
                  color: Colors.white,
                  onTapUp: () {
                    //
                    if (kDebugMode) {
                      print('SHARED DATA FOR VIDEO');
                    }
                    funcShareDataWB(sharedDataStored['postId'].toString());
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWithBoldStyle(
                        'Upload',
                        Colors.green,
                        16.0,
                      ),
                    ],
                  ),
                ),
              ),
              //
              const SizedBox(
                width: 20,
              ),
              //
              Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: NeoPopButton(
                  color: Colors.white,
                  onTapUp: () => setState(() {
                    if (kDebugMode) {
                      print(contWriteSomething.text.length);
                    }
                    if (contWriteSomething.text.isEmpty) {
                      strTextCount = '0';
                    } else {
                      strTextCount = '1';
                    }
                    //
                    strPostType = '1';
                  }),
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWithBoldStyle(
                        'Remove',
                        Colors.red,
                        14.0,
                      ),
                    ],
                  ),
                ),
              ),
              //
            ],
          ),
          //
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Column sharedImageUI(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          //margin: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          // height: 70,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0, left: 10.0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      image: (sharedDataStored['Userimage'].toString() == '')
                          ? const DecorationImage(
                              image: AssetImage(
                                'assets/icons/avatar.png',
                              ),
                              fit: BoxFit.fitHeight,
                            )
                          : DecorationImage(
                              image: NetworkImage(
                                sharedDataStored['Userimage'].toString(),
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
                      // height: 100,
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
                                      sharedDataStored['userId'].toString(),
                                ),
                              ),
                            );
                            //
                          },
                          child: RichText(
                            text: TextSpan(
                              //
                              text: sharedDataStored['fullName'].toString(),
                              //
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
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
                                  text: '\n${timeago.format(
                                    DateTime.parse(
                                      sharedDataStored['created'].toString(),
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
                  sharedDataStored['message'].toString(),
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
                  itemCount: sharedDataStored['postImage'].length,
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
                              sharedDataStored['postImage'][pagePosition]
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                                '$currentIndex / ${sharedDataStored['postImage'].length}',
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
            ],
          ),
        ),
        //

        //
        //
        const SizedBox(
          height: 10,
        ),
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: NeoPopButton(
                color: Colors.white,
                onTapUp: () {
                  //
                  if (kDebugMode) {
                    print('SHARE DATA TEXT');
                  }
                  funcShareDataWB(sharedDataStored['postId'].toString());
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithBoldStyle(
                      'Upload',
                      Colors.green,
                      16.0,
                    ),
                  ],
                ),
              ),
            ),
            //
            const SizedBox(
              width: 20,
            ),
            //
            Container(
              height: 40,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: NeoPopButton(
                color: Colors.white,
                onTapUp: () => setState(() {
                  if (kDebugMode) {
                    print(contWriteSomething.text.length);
                  }
                  if (contWriteSomething.text.isEmpty) {
                    strTextCount = '0';
                  } else {
                    strTextCount = '1';
                  }
                  //
                  strPostType = '1';
                }),
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithBoldStyle(
                      'Remove',
                      Colors.red,
                      14.0,
                    ),
                  ],
                ),
              ),
            ),
            //
          ],
        ),
        //
      ],
    );
  }

  Column shareMethodUI(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
            //margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            // height: 70,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 10.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        image: (sharedDataStored['Userimage'].toString() == '')
                            ? const DecorationImage(
                                image: AssetImage(
                                  'assets/icons/avatar.png',
                                ),
                                fit: BoxFit.fitHeight,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                  sharedDataStored['Userimage'].toString(),
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
                        // height: 100,
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
                                        sharedDataStored['userId'].toString(),
                                  ),
                                ),
                              );
                              //
                            },
                            child: RichText(
                              text: TextSpan(
                                //
                                text: sharedDataStored['fullName'].toString(),
                                //
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
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
                                    text: '\n${timeago.format(
                                      DateTime.parse(
                                        sharedDataStored['created'].toString(),
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
                    sharedDataStored['message'].toString(),
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
            )),
        //

        //
        //
        const SizedBox(
          height: 10,
        ),
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: NeoPopButton(
                color: Colors.white,
                onTapUp: () {
                  //
                  if (kDebugMode) {
                    print('SHARE DATA');
                  }
                  funcShareDataWB(
                    sharedDataStored['postId'].toString(),
                  );
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithBoldStyle(
                      'Upload',
                      Colors.green,
                      16.0,
                    ),
                  ],
                ),
              ),
            ),
            //
            const SizedBox(
              width: 20,
            ),
            //
            Container(
              height: 40,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: NeoPopButton(
                color: Colors.white,
                onTapUp: () => setState(() {
                  if (kDebugMode) {
                    print(contWriteSomething.text.length);
                  }
                  if (contWriteSomething.text.isEmpty) {
                    strTextCount = '0';
                  } else {
                    strTextCount = '1';
                  }
                  //
                  strPostType = '1';
                }),
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithBoldStyle(
                      'Remove',
                      Colors.red,
                      14.0,
                    ),
                  ],
                ),
              ),
            ),
            //
          ],
        ),
        //
      ],
    );
  }

  //
  void deletePostFromMenu(
    BuildContext context,
    String strGetPostId,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Delete post'),
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

  //
  void reportPostFromMenu(
    BuildContext context,
    String strGetPostId,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Report'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              reportPostFromServer(
                strGetPostId.toString(),
              );
              //
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

  //

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

              blockUserWB(strGetBlockFriend);
            },
            child: textWithRegularStyle(
              'Block User',
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
              Colors.black,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

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
              selectImages();
              //
              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              // if (pickedFile != null) {
              //   setState(() {
              //     if (kDebugMode) {
              //       print('object');
              //     }
              //     // when user select photo from gallery
              //     strPostType = '2';
              //     // hide send button for text
              //     strTextCount = '0';
              //     //
              //     imageFile = File(pickedFile.path);
              //   });
              // }
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
                  // when user select photo from gallery
                  strPostType = '2';
                  // hide send button for text
                  strTextCount = '0';
                  //
                  imageFile = File(pickedFile.path);
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

              setState(() {
                if (kDebugMode) {
                  print('object 3');
                }
                // when user select photo from gallery
                strPostType = '4';
                // hide send button for text
                strTextCount = '0';
                //
              });
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

    setState(() {
      // when user select photo from gallery
      strPostType = '2';
      // hide send button for text
      strTextCount = '0';
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
  }

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
        strPostType = '3';
        // hide send button for text
        strTextCount = '0';
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
      });
    }
  }

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
          'action': 'blockunblock',
          'userId': strGetUserId.toString(),
          'blockId': strGetFriendIdIs.toString(),
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
        contWriteSomething.text = '';
        strPostType = '1';
        strTextCount = '0';
        //
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'yes',
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

  // upload feeds data to time line
  funcUploadDataWithOnlyText() async {
    //
    setState(() {
      strPostType = 'loader';
    });
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
        arrHomePosts.clear();
        //
        contWriteSomething.text = '';
        strPostType = '1';
        strTextCount = '0';
        //
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

  // upload feeds data to time line
  funcSendLocationToServer(
    String customMessageIncludeLatLong,
  ) async {
    //
    setState(() {
      strPostType = 'loader';
    });
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
          'message': customMessageIncludeLatLong.toString(),
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
        arrHomePosts.clear();
        //
        contWriteSomething.text = '';
        strPostType = '1';
        strTextCount = '0';
        //
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

  // UPLOAD DATA WITH IMAGE
  uploadImageWithOrWithoutText() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      strPostType = 'loader';
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        applicationBaseURL,
      ),
    );

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime.now(),
    );

    request.fields['action'] = 'posthome';

    request.fields['userId'] = strGetUserId.toString();
    request.fields['message'] = contWriteSomething.text.toString();
    request.fields['postType'] = 'Image'.toString();
    request.fields['created'] = formattedDate.toString();

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
      arrHomePosts.clear();
      //
      contWriteSomething.text = '';
      strPostType = '1';
      strTextCount = '0';

      //
      funcSendUserIdToGetHomeData(
        strGetUserId.toString(),
        'no',
        1,
      );
      //
    } else {
      setState(() {
        strPostType =
            '1'; // remove circular progress bar after successfully load
      });
    }

    //
  }

  //
  uploadMultipleImagesOnServer(
    String postType,
  ) async {
    if (postType == 'Image') {
      if (kDebugMode) {
        print('USER WANTS TO UPLOAD PHOTOS');
      }
    } else {
      if (kDebugMode) {
        print('USER WANTS TO UPLOAD VIDEO');
      }
    }
    // setState(() {});

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    //
    // dismissPopup = '1';
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

    if (kDebugMode) {
      // print('dishant rajput');
      // print(imageFileList!);
    }

    // List<http.MultipartFile> newList = [];

    // List<http.MultipartFile> newList = [];

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
      arrHomePosts.clear();
      //
      contWriteSomething.text = '';
      strPostType = '1';
      strTextCount = '0';

      //

      Navigator.pop(context);
      //
      funcSendUserIdToGetHomeData(
        strGetUserId.toString(),
        'no',
        1,
      );
      //
    }
  }

  //
  // UPLOAD DATA WITH IMAGE
  uploadVideo() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      strPostType = 'loader';
    });

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
    // request.fields['message'] = contWriteSomething.text.toString();
    request.fields['postType'] = 'Video'.toString();
    request.fields['created'] = formattedDate.toString();

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
      arrHomePosts.clear();
      //
      contWriteSomething.text = '';
      strPostType = '1';
      strTextCount = '0';

      //
      funcSendUserIdToGetHomeData(
        strGetUserId.toString(),
        'no',
        1,
      );
      //
    } else {
      setState(() {
        strPostType =
            '1'; // remove circular progress bar after successfully load
      });
    }

    //
  }

// upload feeds data to time line
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
        funcSendUserIdToGetHomeData(
          strGetUserId.toString(),
          'yes',
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
  // upload feeds data to time line
  reportPostFromServer(
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
      text: 'reporting...',
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
          'postId': postId.toString(),
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
        refreshAfterReport(
          strGetUserId.toString(),
          'yes',
          1,
        );
        //
      } else {
        if (kDebugMode) {}
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Something went wrong. Please try again after sometime.'
              .toString(),
        );
      }
    } else {
      // return postList;
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text:
            'Something went wrong. Please try again after sometime.'.toString(),
      );
    }
  }

  //
  refreshAfterReport(
    strLoginUserId,
    strBack,
    pageControlIs,
  ) {
    homeApiCall
        .homeWB(
      strLoginUserId.toString(),
      'Other',
      1,
    )
        .then((value1) {
      // if (kDebugMode) {}
      //
      arrHomePosts.clear();
      //
      for (int i = 0; i < value1.length; i++) {
        arrHomePosts.add(value1[i]);
      }

      //
      if (strLikePress == '1') {
        Navigator.pop(context);
      }

      if (pageControl != 1) {
        Navigator.pop(context);
      }

      //

      setState(() {
        strHomeloader = '1';
        // strDeleteScreenLoader = '1';
        if (strBack == 'yes') {
          Navigator.pop(context);
        }
      });
    });
  }

  //
  funcPlayVideo(videoURL) {
    // print(videoURL);
    _controller2 = VideoPlayerController.network(
      videoURL,
    );

    _initializeVideoPlayerFuture2 = _controller2!.initialize();
    // _controller2.play();
    setState(() {
      strListVideoPlay = '1';
    });
  }

  //
  void _onMapCreated(GoogleMapController controller) {
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
  Future<File> _generateThumbnail(videoURL) async {
    // final Directory tempDir = await getTemporaryDirectory();

    final String? _path = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: (await getTemporaryDirectory()).path,

      /// path_provider
      imageFormat: ImageFormat.PNG,
      maxHeight: 50,
      quality: 50,
    );
    thumbNailImageFile = File(_path!);

    if (kDebugMode) {
      print(thumbNailImageFile);
    }
    return File(_path);
  }

  ///
  ///
  ///
  ///
  ///action:posthome
  // upload feeds data to time line
  funcShareDataWB(
    String strShareId,
  ) async {
    //
    setState(() {
      strPostType = 'loader';
    });
    //
    if (kDebugMode) {
      print('=====> POST : SHARE DATA');
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
          'postType': sharedPostType.toString(),
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
        arrHomePosts.clear();
        //
        contWriteSomething.text = '';
        strPostType = '1';
        strTextCount = '0';
        //
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
}
