// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../controllers/database/database_helper.dart';
import '../controllers/home/home_feeds_for_location/home_feeds_for_location.dart';
import '../controllers/home/home_feeds_shared_location/home_feed_shared_location.dart';
import '../controllers/home/home_like_modal/home_like_modal.dart';
import '../header/utils.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen(
      {super.key, this.dictGetPostId, required this.strPostType});

  final dictGetPostId;
  final String strPostType;

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  //
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  //
  final homeLikeUnlikeApiCall = HomeLikeModal();
  //
  var strCommentsScreen = '0';
  var arrCommentList = [];
  var strShowCommentListOrNot = '0';
  //
  late DataBase handler;
  var strGetUserId = '';
  var dictGetNotificationDetails;
  var strLoaderAndMessage = '0';
  var strImageCount = 0;
  late int currentIndex;
  var strLikePress = '0';
  //
  var strPlayPause = '0';
  //
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  //
  late VideoPlayerController _controller2;
  late Future<void> _initializeVideoPlayerFuture2;
  //
  var strListVideoPlay = '0';
  //
  //
  @override
  void initState() {
    //
    if (kDebugMode) {
      // print(widget.dictGetPostId);
    }
    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
    super.initState();
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
                notificationListWB('no'),
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
          16.0,
        ),
        backgroundColor: navigationColor,
      ),
      body: (strLoaderAndMessage == '0')
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                if (dictGetNotificationDetails['postType'] == 'Text') ...[
                  // text

                  //
                  if (dictGetNotificationDetails['share'] == null) ...[
                    textDataIsNormalUI(context),
                    //
                    //
                    if (widget.strPostType != 'comment') ...[
                      likePostStructureUI(context),
                    ] else ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ), //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator(
                          color: Colors.brown,
                        )
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        commentListUI(context),
                      //
                    ],
                    //
                  ] else ...[
                    sharedTextDataUI(context),
                    //
                    (widget.strPostType != 'comment')
                        ? likePostStructureUI(context)
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: textWithBoldStyle(
                              ' Comments',
                              Colors.black,
                              20.0,
                            ),
                          ),
                    //
                    //
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    commentListUI(context),
                    // //
                  ],
                  //
                ] else if (dictGetNotificationDetails['postType'] == 'Map') ...[
                  //
                  if (dictGetNotificationDetails['share'] == null) ...[
                    //
                    locationNotSharedHeaderUI(context),
                    HomeFeedsForLocation(getData: dictGetNotificationDetails),
                    // likeCommentShareInMap(context, i),
                    //
                    if (widget.strPostType != 'comment') ...[
                      // const SizedBox()
                      //
                      likePostStructureUI(context),
                      //
                    ] else ...[
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      (arrCommentList.isEmpty)
                          ? const SizedBox()
                          : commentListUI(context),
                      //
                    ]
                    //
                  ] else ...[
                    // If someone shared someone's location

                    whenUserSharedSomeoneElseLocationUI(context),
                    //
                    //
                    if (widget.strPostType != 'comment') ...[
                      //
                      likePostStructureUI(context),
                      //
                    ] else ...[
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      (arrCommentList.isEmpty)
                          ? const SizedBox()
                          : commentListUI(context),
                      //
                    ]
                    //
                  ]
                  //
                ] else if (dictGetNotificationDetails['postType'] ==
                    'Image') ...[
                  // image

                  if (dictGetNotificationDetails['share'] == null) ...[
                    // deletePostWB(context, 'image'),
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
                        itemCount:
                            dictGetNotificationDetails['postImage'].length,
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
                                    dictGetNotificationDetails['postImage']
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
                                      '$currentIndex / ${dictGetNotificationDetails['postImage'].length}',
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
                    if (widget.strPostType != 'comment') ...[
                      //
                      likePostStructureUI(context),
                      //
                    ] else ...[
                      //
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      (arrCommentList.isEmpty)
                          ? const SizedBox()
                          : commentListUI(context),
                      //
                    ]
                    //
                    //pageind
                  ] else ...[
                    //
                    //
                    feedsImageNotSharedUI(context),
                    //
                    //
                    (arrCommentList.isEmpty)
                        ? const SizedBox()
                        : commentListUI(context),
                    //
                    //
                    likePostStructureUI(context)
                    //
                    /*Container(
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
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          image: (dictGetNotificationDetails[
                                                          'share']['userImage']
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
                                                    dictGetNotificationDetails[
                                                                'share']
                                                            ['userImage']
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),

                                      //

                                      /*Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          color: Colors.transparent,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         MyProfileScreen(
                                                //       strUserId:
                                                //           dictGetNotificationDetails[
                                                //                   'userId']
                                                //               .toString(),
                                                //     ),
                                                //   ),
                                                // );
                                                //
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  //
                                                  text:
                                                      dictGetNotificationDetails[
                                                                  'share']
                                                              ['userName']
                                                          .toString(),

                                                  //
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  children: const <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          ' shared some image ',
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
                                      ),*/
                                      //
                                    ],
                                  ),
                                  // child: widget
                                ),

                                /* Container(
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
                                    dictGetNotificationDetails['share']
                                            ['message']
                                        .toString(),
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
                                ),*/
                                //
                              ],
                            ),
                          ),
                          //
                          dictGetNotificationDetails(
                            context,
                          ),
                          //
                        ],
                      ),
                    ),*/
                    //

                    //
                    // likePostStructureUI(context, i)
                    //
                  ]

                  //
                ] else if (dictGetNotificationDetails['postType'] ==
                    'Video') ...[
                  //
                  if (dictGetNotificationDetails['share'] != null) ...[
                    //
                    Container(
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
                                    image:
                                        (dictGetNotificationDetails['Userimage']
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
                                                  dictGetNotificationDetails[
                                                          'Userimage']
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         MyProfileScreen(
                                          //       strUserId:
                                          //           dictGetNotificationDetails[
                                          //                   'userId']
                                          //               .toString(),
                                          //     ),
                                          //   ),
                                          // );
                                          //
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            //
                                            text: dictGetNotificationDetails[
                                                    'fullName']
                                                .toString(),
                                            //
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: const <TextSpan>[
                                              TextSpan(
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
                                /*(strGetUserId.toString() ==
                                        dictGetNotificationDetails['userId']
                                            .toString())
                                    ? IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('open action sheet');
                                          }
                                          //
                                          // deletePostFromMenu(
                                          //   context,
                                          //   dictGetNotificationDetails['postId']
                                          //       .toString(),
                                          // );
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
                                          // print(dictGetNotificationDetails);
                                          // blockUserPostFromMenu(context,
                                          //     dictGetNotificationDetails['userId'].toString());
                                          //
                                        },
                                        icon: const Icon(
                                          Icons.menu,
                                        ),
                                      ),*/
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
                              dictGetNotificationDetails['message'].toString(),
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
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          image: (dictGetNotificationDetails[
                                                          'share']['userImage']
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
                                                    dictGetNotificationDetails[
                                                                'share']
                                                            ['userImage']
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
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         MyProfileScreen(
                                                //       strUserId:
                                                //           dictGetNotificationDetails[
                                                //                   'userId']
                                                //               .toString(),
                                                //     ),
                                                //   ),
                                                // );
                                                //
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  //
                                                  text:
                                                      dictGetNotificationDetails[
                                                                  'share']
                                                              ['userName']
                                                          .toString(),
                                                  //
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  children: const <TextSpan>[
                                                    TextSpan(
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
                                    dictGetNotificationDetails['share']
                                            ['message']
                                        .toString(),
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
                                        // print(dictGetNotificationDetails['postImage']);
                                      }

                                      funcPlayVideo(
                                          dictGetNotificationDetails['share']
                                              ['postImage'][0]['name']);
                                      // _controller2.play();
                                      //
                                      /*
                                    */
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel:
                                              MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                          barrierColor: Colors.black87,
                                          transitionDuration:
                                              const Duration(milliseconds: 200),
                                          pageBuilder: (BuildContext
                                                  buildContext,
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
                                                      if (strListVideoPlay ==
                                                          '0') {
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
                                                      future:
                                                          _initializeVideoPlayerFuture2,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          return AspectRatio(
                                                            aspectRatio:
                                                                _controller2
                                                                    .value
                                                                    .aspectRatio,
                                                            // width: MediaQuery.of(context)
                                                            // .size
                                                            // .width -
                                                            // 10,
                                                            //  height:
                                                            // 360,
                                                            child: Stack(
                                                              fit: StackFit
                                                                  .expand,
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
                                                                (strListVideoPlay ==
                                                                        '1')
                                                                    ? Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                Container(
                                                                              height: 40,
                                                                              width: 40,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.transparent,
                                                                                borderRadius: BorderRadius.circular(
                                                                                  24.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          //
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.all(10.0),
                                                                            width:
                                                                                48.0,
                                                                            height:
                                                                                48.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey,
                                                                              borderRadius: BorderRadius.circular(
                                                                                24.0,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.play_arrow,
                                                                            ),
                                                                          ),
                                                                          //
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                Container(
                                                                              height: 40,
                                                                              width: 40,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey,
                                                                                borderRadius: BorderRadius.circular(
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
                                                                        height:
                                                                            10,
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
                                          dictGetNotificationDetails['share']
                                                  ['postImage'][0]['name']
                                              .toString(),
                                        ),
                                        builder: (context, snapshot) {
                                          // f (snapshot.connectionState ==
                                          // ConnectionState.done) {
                                          return Container(
                                            // margin: const EdgeInsets.all(10.0),
                                            color: Colors.grey,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 240,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                //
                                                Container(
                                                  // margin: const EdgeInsets.all(10.0),
                                                  color: Colors.purple,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 220,
                                                  child: (snapshot.data == null)
                                                      ? Image.asset(
                                                          'assets/icons/avatar.png',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          File(
                                                            snapshot.data
                                                                .toString(),
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                //
                                                (strPlayPause == '0')
                                                    ? Center(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          width: 48.0,
                                                          height: 48.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
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
                    ),
                    //
                    // textWithRegularStyle(
                    //   'str',
                    //   Colors.amber,
                    //   14.0,
                    // ),
                    if (widget.strPostType != 'comment') ...[
                      // const SizedBox()
                      //
                      likePostStructureUI(context),
                      //
                    ] else ...[
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      (arrCommentList.isEmpty)
                          ? const SizedBox()
                          : commentListUI(context),
                      //

                      //
                    ],
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
                  ] else ...[
                    // deletePostWB(context, 'video', i),
                    //

                    InkWell(
                      onTap: () {
                        if (kDebugMode) {
                          print(dictGetNotificationDetails['postImage']);
                        }

                        funcPlayVideo(
                            dictGetNotificationDetails['postImage'][0]['name']);
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
                                              aspectRatio: _controller2
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
                                                                          .all(
                                                                      10.0),
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
                                                                Icons
                                                                    .play_arrow,
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
                            dictGetNotificationDetails['postImage'][0]['name']
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
                    if (widget.strPostType != 'comment') ...[
                      // const SizedBox()
                      //
                      likePostStructureUI(context),
                      //
                    ] else ...[
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          ' Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      (arrCommentList.isEmpty)
                          ? const SizedBox()
                          : commentListUI(context),
                      //

                      //
                    ]
                    //
                  ],
                ]
              ],
            ),
    );
  }

//
  Container feedsImageNotSharedUI(BuildContext context) {
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
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          image: (dictGetNotificationDetails['share']
                                          ['userImage']
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
                                    dictGetNotificationDetails['share']
                                            ['userImage']
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => MyProfileScreen(
                                //       strUserId:
                                //           dictGetNotificationDetails['userId'].toString(),
                                //     ),
                                //   ),
                                // );
                                //
                              },
                              child: RichText(
                                text: TextSpan(
                                  //
                                  text: dictGetNotificationDetails['fullName']
                                      .toString(),
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
                                          dictGetNotificationDetails['created']
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
                      /*(strGetUserId.toString() ==
                              dictGetNotificationDetails['userId'].toString())
                          ? IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('open action sheet');
                                }
                                //
                                // deletePostFromMenu(
                                //   context,
                                //   dictGetNotificationDetails['postId'].toString(),
                                // );
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
                                //   dictGetNotificationDetails['postId'].toString(),
                                // );
                                //
                              },
                              icon: const Icon(
                                Icons.menu,
                              ),
                            )*/
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
                    dictGetNotificationDetails['message'].toString(),
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
          shardImageDataUI(context),
          //
        ],
      ),
    );
  }

  //
  Container likePostStructureUI(BuildContext context) {
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
                        // print(dictGetNotificationDetails['youliked'].toString());
                        // print(dictGetNotificationDetails['postId'].toString());
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

                      (dictGetNotificationDetails['youliked'].toString() ==
                              'No')
                          ? homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                dictGetNotificationDetails['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                        strGetUserId.toString(), 'no'),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                dictGetNotificationDetails['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                        strGetUserId.toString(), 'no'),
                                  });
                    },
                    icon: (dictGetNotificationDetails['youliked'].toString() ==
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
                    '${dictGetNotificationDetails['likesCount'].toString()} like',
                    Colors.black,
                    14.0,
                  ),
                  //
                ],
              ),
            ),
          ),
          //
          /*Expanded(
            child: InkWell(
              onTap: () {
                //
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HomeFeedsCommentsScreen(
                //       getDataForComment: dictGetNotificationDetails,
                //     ),
                //   ),
                // );
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
          ),*/
          //
          /*Expanded(
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
                      /*if (dictGetNotificationDetails['message'][0] == '!') {
                        setState(() {
                          if (kDebugMode) {
                            print('======> USER SHARE LOCATION <======');
                          }
                          contWriteSomething.text = '';
                          strPostType = '8';
                          strTextCount = '0';
                          sharedPostType = 'Text';
                          //
                          sharedDataStored = dictGetNotificationDetails;
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
                          sharedDataStored = dictGetNotificationDetails;
                          //
                        });
                      }*/
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
          ),*/
          //
        ],
      ),
    );
  }

  //
  funcSendUserIdToGetHomeData(
    strLoginUserId,
    strBack,
  ) {
    //
    notificationListWB('hide_pop_up');
//
  }

  Column commentListUI(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < arrCommentList.length; i++) ...[
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
              // bottom: 40,
            ),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 80,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        image: (arrCommentList[i]['Userimage'].toString() == '')
                            ? const DecorationImage(
                                image: AssetImage(
                                  'assets/icons/avatar.png',
                                ),
                                fit: BoxFit.fitHeight,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                  arrCommentList[i]['Userimage'].toString(),
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    ),
                    //
                    const SizedBox(
                      width: 10,
                    ),
                    //
                    Expanded(
                      child: textWithBoldStyle(
                        //
                        arrCommentList[i]['fullName'].toString(),
                        //
                        Colors.black,
                        16.0,
                      ),
                    ),
                    //
                    (arrCommentList[i]['userId'].toString() == strGetUserId)
                        ? IconButton(
                            onPressed: () {
                              //
                              deleteCommentPopup(
                                  context,
                                  arrCommentList[i]['postId'].toString(),
                                  arrCommentList[i]['commentId'].toString());
                              //
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          )
                  ],
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 60.0,
                    bottom: 10,
                    right: 20,
                  ),
                  alignment: Alignment.centerLeft,
                  child: ReadMoreText(
                    //
                    arrCommentList[i]['comment'].toString(),
                    //
                    trimLines: 4,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  /* textWithRegularStyle(
                                    //
                                    arrCommentList[i]['comment'].toString(),
                                    //
                                    Colors.black,
                                    14.0,
                                  ),*/
                ),
                //
                Center(
                  child: Container(
                    // margin: const EdgeInsets.all(10.0),
                    color: const Color.fromRGBO(
                      240,
                      240,
                      240,
                      1,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 10,
                    // child: widget
                  ),
                ),
                //
              ],
            ),
          ),
        ],
      ],
    );
  }

  void deleteCommentPopup(
    BuildContext context,
    String strPostId,
    String strCommentId,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Are you sure you want to delete this comment ?'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              deleteCommentWB(
                strPostId,
                strCommentId,
              );
            },
            child: textWithRegularStyle(
              'Yes, delete',
              Colors.redAccent,
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

// upload feeds data to time line
  deleteCommentWB(strGetFriendIdIs, strCommentId) async {
    //
    setState(() {
      strCommentsScreen = '0';
    });
    //
    if (kDebugMode) {
      print('=====> POST : DELETE COMMENT ');
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
          'action': 'deletecomment',
          'userId': strGetUserId.toString(),
          'postId': strGetFriendIdIs.toString(),
          'commentId': strCommentId.toString(),
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
        getCommentList();
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

  Padding whenUserSharedSomeoneElseLocationUI(BuildContext context) {
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
            locationNotSharedHeaderUI(context),
            //
            if (dictGetNotificationDetails['message'].toString() == '')
              ...[]
            else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dictGetNotificationDetails['message']..toString(),
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
                    locationSharedAndSetImageProfileWithNameHeaderUI(context),
                    //
                    if (dictGetNotificationDetails['share']['message']
                            .split(',')[2] ==
                        '')
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dictGetNotificationDetails['share']['message']
                                .split(',')[2],
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
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(dictGetNotificationDetails['share']
                                    ['message']
                                .split(',')[0]),
                            double.parse(dictGetNotificationDetails['share']
                                    ['message']
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

  void _onMapCreated(GoogleMapController controller) {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        double.parse(
          dictGetNotificationDetails['share']['message'].split(',')[0],
        ),
        double.parse(
          dictGetNotificationDetails['share']['message'].split(',')[1],
        ),
      ),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: 'qwer',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });
  }

  getCommentList() async {
    if (kDebugMode) {
      print('=====> POST : COMMENTS LIST');
      print(dictGetNotificationDetails['postId'].toString());
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'commentlist',
          'userId': '', //strGetUserId.toString(),
          'postId': dictGetNotificationDetails['postId'].toString(),
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
        arrCommentList.clear();
        //
        for (var i = 0; i < getData['data'].length; i++) {
          arrCommentList.add(getData['data'][i]);
        }
        //
        if (arrCommentList.isEmpty) {
          strCommentsScreen = '1';
        } else {
          strCommentsScreen = '2';
        }
        setState(() {
          strLoaderAndMessage = '1';

          //
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

  Container locationSharedAndSetImageProfileWithNameHeaderUI(
      BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),

      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          if (strGetUserId ==
              dictGetNotificationDetails['userId'].toString()) ...[
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
                image: (dictGetNotificationDetails['share']['userImage']
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
                          dictGetNotificationDetails['share']['userImage']
                              .toString(),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
              ),
            )
            //
          ] else if (dictGetNotificationDetails['friendStatus'].toString() ==
                  '0' ||
              dictGetNotificationDetails['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '1') ...[
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
                  image: (dictGetNotificationDetails['share']['userImage']
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
                            dictGetNotificationDetails['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
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
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
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
          ] else if (dictGetNotificationDetails['friendStatus'].toString() ==
              '2') ...[
            // THEY BOTH ARE FRIENDS
            if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '1') ...[
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
                  image: (dictGetNotificationDetails['share']['userImage']
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
                            dictGetNotificationDetails['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
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
                  image: (dictGetNotificationDetails['share']['userImage']
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
                            dictGetNotificationDetails['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyProfileScreen(
                    //       strUserId:
                    //           dictGetNotificationDetails['userId'].toString(),
                    //     ),
                    //   ),
                    // );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: dictGetNotificationDetails['share']['userName']
                          .toString(),
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
                              dictGetNotificationDetails['share']['created']
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

          //
        ],
      ),
      // child: widget
    );
  }

  Container locationNotSharedHeaderUI(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),

      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          /*if (strGetUserId ==
              dictGetNotificationDetails['userId'].toString()) ...[
            //
            matchImageUserLoginProfilematched(),
            //
          ] else if (dictGetNotificationDetails['friendStatus'].toString() ==
                  '0' ||
              dictGetNotificationDetails['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '1') ...[
              //
              userIsNoFriendAndProfileSetToEveryone(),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '2') ...[
              //
              userIsNoFriendAndProfileSetToOnlyFriends(),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '3') ...[
              //
              userIsNoFriendAndProfileSetToOnlyMe(),
              //
            ],
          ] else if (dictGetNotificationDetails['friendStatus'].toString() ==
              '2') ...[
            // THEY BOTH ARE FRIENDS
            if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '1') ...[
              //
              userIsYesFriendAndProfileSetToEveryone(),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '2') ...[
              //
              userIsYesFriendAndProfileSetToOnlyFriends(),
              //
            ] else if (dictGetNotificationDetails['SettingProfilePicture']
                    .toString() ==
                '3') ...[
              //
              userIsYesFriendAndProfileSetToOnlyMe(),
              //
            ],
          ],*/

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
              image: (dictGetNotificationDetails['Userimage'].toString() == '')
                  ? const DecorationImage(
                      image: AssetImage(
                        'assets/icons/avatar.png',
                      ),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(
                        dictGetNotificationDetails['Userimage'].toString(),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyProfileScreen(
                    //       strUserId: dictGetNotificationDetails['userId'].toString(),
                    //     ),
                    //   ),
                    // );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: dictGetNotificationDetails['fullName'].toString(),
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
                              dictGetNotificationDetails['created'].toString(),
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
          /*(strGetUserId.toString() ==
                  dictGetNotificationDetails['userId'].toString())
              ? IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print('open action sheet');
                    }
                    //
                    // deletePostFromMenu(
                    //   context,
                    //   dictGetNotificationDetails['postId'].toString(),
                    // );
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
                    //   dictGetNotificationDetails['postId'].toString(),
                    // );
                    //
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                )*/
          //
        ],
      ),
      // child: widget
    );
  }

  //
  Container sharedTextDataUI(BuildContext context) {
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
                    image:
                        (dictGetNotificationDetails['Userimage'].toString() ==
                                '')
                            ? const DecorationImage(
                                image: AssetImage(
                                  'assets/icons/avatar.png',
                                ),
                                fit: BoxFit.fitHeight,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                  dictGetNotificationDetails['Userimage']
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyProfileScreen(
                          //       strUserId: dictGetNotificationDetails['userId'].toString(),
                          //     ),
                          //   ),
                          // );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: dictGetNotificationDetails['fullName']
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
                (strGetUserId.toString() ==
                        dictGetNotificationDetails['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   dictGetNotificationDetails['postId'].toString(),
                          // );
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
          if (dictGetNotificationDetails['message'].toString() != '') ...[
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
                dictGetNotificationDetails['message'].toString(),
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
                            // print(dictGetNotificationDetails['share']);
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
                              image: (dictGetNotificationDetails['share']
                                              ['userImage']
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
                                        dictGetNotificationDetails['share']
                                                ['userImage']
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => MyProfileScreen(
                                  //       strUserId: dictGetNotificationDetails['userId']
                                  //           .toString(),
                                  //     ),
                                  //   ),
                                  // );
                                  //
                                },
                                child: RichText(
                                  text: TextSpan(
                                    //
                                    text: dictGetNotificationDetails['share']
                                            ['userName']
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
                      dictGetNotificationDetails['share']['message'].toString(),
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
        ],
      ),
    );
  }

  //
  notificationListWB(strBack) async {
    //
    if (kDebugMode) {
      print('=====> POST : NOTIFICATION DETAILS');
      print('post type =====> ${widget.strPostType}');
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
          'action': 'postdetails',
          'userId': strGetUserId.toString(),
          'postId': widget.dictGetPostId['messagejson']['postId'].toString()
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

        if (strBack == 'hide_pop_up') {
          Navigator.pop(context);
          if (widget.strPostType == 'comment') {
            //
            dictGetNotificationDetails = getData['data'];
            getCommentList();
            //
          } else {
            setState(() {
              strLoaderAndMessage = '1';
              dictGetNotificationDetails = getData['data'];
              //
            });
          }
        } else {
          if (widget.strPostType == 'comment') {
            //
            dictGetNotificationDetails = getData['data'];
            getCommentList();
            //
          } else {
            setState(() {
              strLoaderAndMessage = '1';
              dictGetNotificationDetails = getData['data'];
              //
            });
          }
        }

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
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Something went wrong. Please try again later.'.toString(),
      );
    }
  }

//
  Container textDataIsNormalUI(BuildContext context) {
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
                //
                matchImageUserLoginProfilematchedForText(),
                //
                /*if (strGetUserId ==
                    dictGetNotificationDetails['userId'].toString()) ...[
                  //
                  matchImageUserLoginProfilematched(),
                  //
                ] else if (dictGetNotificationDetails['friendStatus']
                            .toString() ==
                        '0' ||
                    dictGetNotificationDetails['friendStatus'].toString() ==
                        '1') ...[
                  // 0 = no friend
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsNoFriendAndProfileSetToEveryone(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ] else if (dictGetNotificationDetails['friendStatus']
                        .toString() ==
                    '2') ...[
                  // THEY BOTH ARE FRIENDS
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsYesFriendAndProfileSetToEveryone(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ],*/
                /*InkWell(
                  onTap: () {
                    // print(dictGetNotificationDetails['share']);
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
                      image: (dictGetNotificationDetails['Userimage'].toString() == '')
                          ? const DecorationImage(
                              image: AssetImage(
                                'assets/icons/avatar.png',
                              ),
                              fit: BoxFit.fitHeight,
                            )
                          : DecorationImage(
                              image: NetworkImage(
                                dictGetNotificationDetails['Userimage'].toString(),
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
                          // //
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyProfileScreen(
                          //       strUserId: dictGetNotificationDetails['userId'].toString(),
                          //     ),
                          //   ),
                          // );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: dictGetNotificationDetails['fullName']
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
                /*(strGetUserId.toString() ==
                        dictGetNotificationDetails['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   dictGetNotificationDetails['postId'].toString(),
                          // );
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
                          //   dictGetNotificationDetails['postId'].toString(),
                          // );
                          //
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      ),*/
              ],
            ),
            // child: widget
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              bottom: 10.0,
              right: 10.0,
            ),

            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
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
            // height: 220,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                //
                dictGetNotificationDetails['message'].toString(),
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
          ),
          //
        ],
      ),
    );
  }

  //
  Container matchImageUserLoginProfilematchedSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  //
  Container userIsNoFriendAndProfileSetToEveryoneSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
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

  //
  Container userIsYesFriendAndProfileSetToEveryoneSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
  Container userIsYesFriendAndProfileSetToOnlyFriendsSHARE() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
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
  //
  Container matchImageUserLoginProfilematched() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  Container matchImageUserLoginProfilematchedForText() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['Userimage'].toString() == '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['Userimage'].toString(),
                ),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Container matchImageUserLoginProfilematchedOnlyForImage() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['postImage'][0]['name'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['postImage'][0]['name'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
  Container userIsNoFriendAndProfileSetToEveryone() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
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

  //
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

  //
  Container userIsYesFriendAndProfileSetToEveryone() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
  Container userIsYesFriendAndProfileSetToOnlyFriends() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          30,
        ),
        image: (dictGetNotificationDetails['share']['userImage'].toString() ==
                '')
            ? const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
                fit: BoxFit.fitHeight,
              )
            : DecorationImage(
                image: NetworkImage(
                  dictGetNotificationDetails['share']['userImage'].toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }

  //
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

  //
  Container deletePostWB(
    BuildContext context,
    String strTitle,
  ) {
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
                // if (strGetUserId ==
                // dictGetNotificationDetails['userId'].toString()) ...[
                //
                matchImageUserLoginProfilematchedOnlyForImage(),
                //
                /*] else if (dictGetNotificationDetails['friendStatus']
                            .toString() ==
                        '0' ||
                    dictGetNotificationDetails['friendStatus'].toString() ==
                        '1') ...[
                  // 0 = no friend
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsNoFriendAndProfileSetToEveryone(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyMe(),
                    //
                  ],
                ] else if (dictGetNotificationDetails['friendStatus']
                        .toString() ==
                    '2') ...[
                  // THEY BOTH ARE FRIENDS
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsYesFriendAndProfileSetToEveryone(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyFriends(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyMe(),
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyProfileScreen(
                          //       strUserId: dictGetNotificationDetails['userId']
                          //           .toString(),
                          //     ),
                          //   ),
                          // );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: dictGetNotificationDetails['fullName']
                                .toString(),
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
                              const TextSpan(
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
                (strGetUserId.toString() ==
                        dictGetNotificationDetails['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   dictGetNotificationDetails['postId'].toString(),
                          // );
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
                          // reportPostFromMenu(
                          //   context,
                          //   dictGetNotificationDetails['postId'].toString(),
                          // );
                          // print(dictGetNotificationDetails);
                          // blockUserPostFromMenu(
                          // context, dictGetNotificationDetails['userId'].toString());
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
              dictGetNotificationDetails['message'].toString(),
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
  Container shardImageDataUI(
    BuildContext context,
  ) {
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
                if (strGetUserId ==
                    dictGetNotificationDetails['userId'].toString()) ...[
                  //
                  matchImageUserLoginProfilematchedSHARE(),
                  //
                ] else if (dictGetNotificationDetails['friendStatus']
                            .toString() ==
                        '0' ||
                    dictGetNotificationDetails['friendStatus'].toString() ==
                        '1') ...[
                  // 0 = no friend
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsNoFriendAndProfileSetToEveryoneSHARE(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyFriendsSHARE(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '3') ...[
                    //
                    userIsNoFriendAndProfileSetToOnlyMeSHARE(),
                    //
                  ],
                ] else if (dictGetNotificationDetails['friendStatus']
                        .toString() ==
                    '2') ...[
                  // THEY BOTH ARE FRIENDS
                  if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '1') ...[
                    //
                    userIsYesFriendAndProfileSetToEveryoneSHARE(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
                          .toString() ==
                      '2') ...[
                    //
                    userIsYesFriendAndProfileSetToOnlyFriendsSHARE(),
                    //
                  ] else if (dictGetNotificationDetails['SettingProfilePicture']
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyProfileScreen(
                          //       strUserId: dictGetNotificationDetails['share']['userId']
                          //           .toString(),
                          //     ),
                          //   ),
                          // );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: dictGetNotificationDetails['share']
                                    ['userName']
                                .toString(),
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

          if (dictGetNotificationDetails['message'].toString() == '')
            ...[]
          else ...[
            if (dictGetNotificationDetails['share']['message'].toString() == '')
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
                  dictGetNotificationDetails['share']['message'].toString(),
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
                itemCount:
                    dictGetNotificationDetails['share']['postImage'].length,
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
                            dictGetNotificationDetails['share']['postImage']
                                [pagePosition]['name'],
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
                              '$currentIndex / ${dictGetNotificationDetails['share']['postImage'].length}',
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

  //
  //
  funcPlayVideo(videoURL) {
    print(videoURL);
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
    print('NEW THUMBNAIL IAMGE');
    print(fileName);
  }
  //
}
