import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
// import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:pludin/classes/controllers/home/home_feeds_image_UI/home_feeds_image_UI.dart';
import 'package:pludin/classes/controllers/home/home_feeds_text_UI/home_feeds_text_UI.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../database/database_helper.dart';
import '../../profile/my_profile.dart';
import '../home_feeds_for_location/home_feeds_for_location.dart';
import '../home_like_modal/home_like_modal.dart';

import 'package:timeago/timeago.dart' as timeago;

class HomeFeedsCommentsScreen extends StatefulWidget {
  const HomeFeedsCommentsScreen({super.key, this.getDataForComment});

  final getDataForComment;

  @override
  State<HomeFeedsCommentsScreen> createState() =>
      _HomeFeedsCommentsScreenState();
}

class _HomeFeedsCommentsScreenState extends State<HomeFeedsCommentsScreen> {
  //
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strGetUserId = '';
  var strImage = '';

  late DataBase handler;
  var strCommentsScreen = '0';
  var arrCommentList = [];
  //
  late final TextEditingController contComment;
  //
  var strImageCount = 1;
  //
  var strPlayPause = '0';
  var strListVideoPlay = '0';
  VideoPlayerController? _controller2;
  late Future<void> _initializeVideoPlayerFuture2;
  //
  late int currentIndex;
  var strLikePress = '0';
  final homeLikeUnlikeApiCall = HomeLikeModal();
  //
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.getDataForComment);
    }
    contComment = TextEditingController();
    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
  }

  @override
  void dispose() {
    contComment.dispose();
    _controller2?.dispose();

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
                    // print(value[i].fullName),
                    strGetUserId = value[i].userId.toString(),
                    strImage = value[i].image.toString(),
                    // print('dishant rajput'),
                    // print(strGetUserId),
                  },
                //
                getGrindWB()
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: textWithRegularStyle(
          'Comments',
          Colors.white,
          18.0,
        ),
        leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('object');
            }
            //
            Navigator.pop(context);
            //
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        backgroundColor: navigationColor,
      ),
      body: GestureDetector(
        onTap: () {
          // keyboard dismiss when click outside
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  if (widget.getDataForComment['postType'] == 'Image') ...[
                    //

                    if (widget.getDataForComment['share'] == null) ...[
                      deletePostWB(context),
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
                              widget.getDataForComment['postImage'].length,
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
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  // child:
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      24.0,
                                    ),
                                    child: Image.network(
                                      //
                                      widget.getDataForComment['postImage']
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
                                        '$currentIndex / ${widget.getDataForComment['postImage'].length}',
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
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: textWithBoldStyle(
                          '  Comments',
                          Colors.black,
                          20.0,
                        ),
                      ),
                      //
                      //pageind

                      /*Container(
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
                                          print(widget
                                              .getDataForComment['youliked']
                                              .toString());
                                          print(widget
                                              .getDataForComment['postId']
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

                                        (widget.getDataForComment['youliked']
                                                    .toString() ==
                                                'No')
                                            ? homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '1',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    })
                                            : homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '2',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    });
                                      },
                                      icon: (widget
                                                  .getDataForComment['youliked']
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
                                      '${widget.getDataForComment['likesCount'].toString()} like',
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
                                        getDataForComment:
                                            widget.getDataForComment,
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
                      ),*/
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        commentListUI(context),
                      //
                      const SizedBox(
                        height: 120,
                      ),
                      //
                    ] else ...[
                      //
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
                                      image:
                                          (widget.getDataForComment['Userimage']
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
                                                    widget.getDataForComment[
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfileScreen(
                                                  strUserId: widget
                                                      .getDataForComment[
                                                          'userId']
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                            //
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              //
                                              text: widget
                                                  .getDataForComment['fullName']
                                                  .toString(),
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
                                                      widget.getDataForComment[
                                                              'created']
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
                                  (strGetUserId.toString() ==
                                          widget.getDataForComment['userId']
                                              .toString())
                                      ? IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('open action sheet');
                                            }
                                            //
                                            // deletePostFromMenu(
                                            //   context,
                                            //   widget.getDataForComment['postId']
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
                                              print('open action sheet');
                                            }
                                            //
                                            // print(widget.getDataForComment);
                                            blockUserPostFromMenu(
                                                context,
                                                widget
                                                    .getDataForComment['userId']
                                                    .toString());
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
                                widget.getDataForComment['message'].toString(),
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
                      // likePostStructureUI(context),
                      //
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
                      /*const SizedBox(
                        height: 10,
                      ),
                      //
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                       Column(
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
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            image: (widget.getDataForComment[
                                                            'Userimage']
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
                                                      widget.getDataForComment[
                                                              'Userimage']
                                                          .toString(),
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
                                        textWithBoldStyle(
                                          //
                                          arrCommentList[i]['fullName']
                                              .toString(),
                                          //
                                          Colors.black,
                                          16.0,
                                        ),
                                        //
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                        ),*/
                      //

                      const SizedBox(
                        height: 10,
                      ),
                      //
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        commentListUI(context),
                      //
                      const SizedBox(
                        height: 120,
                      ),
                      //
                    ]

                    //
                  ] else if (widget.getDataForComment['postType'] ==
                      'Text') ...[
                    // text

                    // CHECK IF THIS TEXT POST IS SHARED OR NOT
                    if (widget.getDataForComment['share'] == null) ...[
                      textDataIsNormalUI(context), // normal data
                    ] else ...[
                      sharedTextDataUI(context) // shared data
                    ],
                    //
                    //
                    const SizedBox(
                      height: 30,
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
                    if (strCommentsScreen == '0')
                      const CircularProgressIndicator()
                    else if (strCommentsScreen == '1')
                      textWithBoldStyle(
                        'No comments found',
                        Colors.black,
                        14.0,
                      )
                    else
                      commentListUI(context),
                    //
                    //
                  ] else if (widget.getDataForComment['postType'] == 'Map') ...[
                    //
                    if (widget.getDataForComment['share'] == null) ...[
                      //
                      locationNotSharedHeaderUI(context),
                      HomeFeedsForLocation(getData: widget.getDataForComment),
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
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        commentListUI(context),
                      //
                    ] else ...[
                      // If someone shared someone's location

                      whenUserSharedSomeoneElseLocationUI(context),

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
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        commentListUI(context),
                      //
                      //
                    ]
                    //
                  ] else if (widget.getDataForComment['postType'] ==
                      'Video') ...[
                    // video ui
                    // image
                    // HomeFeedsImageUIScreen(
                    //   getData: widget.getDataForComment,
                    //   strTitle: 'video',
                    // ),
                    // //

                    //

                    if (widget.getDataForComment['share'] != null) ...[
                      // Text(
                      //   'video shared',
                      // ),
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
                                          (widget.getDataForComment['Userimage']
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
                                                    widget.getDataForComment[
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfileScreen(
                                                  strUserId: widget
                                                      .getDataForComment[
                                                          'userId']
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                            //
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              //
                                              text: widget
                                                  .getDataForComment['fullName']
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
                                                      widget.getDataForComment[
                                                              'created']
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
                                  (strGetUserId.toString() ==
                                          widget.getDataForComment['userId']
                                              .toString())
                                      ? IconButton(
                                          onPressed: () {
                                            if (kDebugMode) {
                                              print('open action sheet');
                                            }
                                            // //
                                            // deletePostFromMenu(
                                            //   context,
                                            //   widget.getDataForComment['postId'].toString(),
                                            // );
                                            // //
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
                                            // print(widget.getDataForComment);
                                            blockUserPostFromMenu(
                                                context,
                                                widget
                                                    .getDataForComment['userId']
                                                    .toString());
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
                                widget.getDataForComment['message'].toString(),
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
                                            image: (widget.getDataForComment[
                                                            'share']
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
                                                      widget.getDataForComment[
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                      builder: (context) =>
                                                          MyProfileScreen(
                                                        strUserId: widget
                                                            .getDataForComment[
                                                                'userId']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                  //
                                                },
                                                child: RichText(
                                                  text: TextSpan(
                                                    //
                                                    text: widget
                                                        .getDataForComment[
                                                            'share']['userName']
                                                        .toString(),
                                                    //
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        text:
                                                            '\n${timeago.format(
                                                          DateTime.parse(
                                                            widget
                                                                .getDataForComment[
                                                                    'created']
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
                                      widget.getDataForComment['share']
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
                                          // print(widget.getDataForComment['postImage']);
                                        }

                                        funcPlayVideo(
                                            widget.getDataForComment['share']
                                                ['postImage'][0]['name']);
                                        // _controller2.play();
                                        //
                                        /*
                                    */
                                        showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel:
                                                MaterialLocalizations.of(
                                                        context)
                                                    .modalBarrierDismissLabel,
                                            barrierColor: Colors.black87,
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
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
                                                          strListVideoPlay =
                                                              '1';
                                                          _controller2?.pause();
                                                        } else {
                                                          strListVideoPlay =
                                                              '0';
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
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                            return AspectRatio(
                                                              aspectRatio:
                                                                  _controller2!
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
                                                                    _controller2!,
                                                                  ),
                                                                  //
                                                                  (strListVideoPlay ==
                                                                          '1')
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
                                                                                  borderRadius: BorderRadius.circular(
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
                                            widget.getDataForComment['share']
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 220,
                                                    child: (snapshot.data ==
                                                            null)
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
                                          print(widget
                                              .getDataForComment['youliked']
                                              .toString());
                                          print(widget
                                              .getDataForComment['postId']
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

                                        (widget.getDataForComment['youliked']
                                                    .toString() ==
                                                'No')
                                            ? homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '1',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    })
                                            : homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '2',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    });
                                      },
                                      icon: (widget
                                                  .getDataForComment['youliked']
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
                                      '${widget.getDataForComment['likesCount'].toString()} like',
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
                                        getDataForComment:
                                            widget.getDataForComment,
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
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        Column(
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
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            image: (arrCommentList[i]
                                                            ['Userimage']
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
                                                      arrCommentList[i]
                                                              ['Userimage']
                                                          .toString(),
                                                    ),
                                                    fit: BoxFit.cover,
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
                                            arrCommentList[i]['fullName']
                                                .toString(),
                                            //
                                            Colors.black,
                                            16.0,
                                          ),
                                        ),
                                        //
                                        (arrCommentList[i]['userId']
                                                    .toString() ==
                                                strGetUserId)
                                            ? IconButton(
                                                onPressed: () {
                                                  //
                                                  deleteCommentPopup(
                                                      context,
                                                      arrCommentList[i]
                                                              ['postId']
                                                          .toString(),
                                                      arrCommentList[i]
                                                              ['commentId']
                                                          .toString());
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                        ),
                      //
                      const SizedBox(
                        height: 80,
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
                      deletePostWB(context),
                      //

                      InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(widget.getDataForComment['postImage']);
                          }

                          funcPlayVideo(
                              widget.getDataForComment['postImage'][0]['name']);
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
                                          future: _initializeVideoPlayerFuture2,
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
                              widget.getDataForComment['postImage'][0]['name']
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

                      /*Container(
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
                                          print(widget
                                              .getDataForComment['youliked']
                                              .toString());
                                          print(widget
                                              .getDataForComment['postId']
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

                                        (widget.getDataForComment['youliked']
                                                    .toString() ==
                                                'No')
                                            ? homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '1',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    })
                                            : homeLikeUnlikeApiCall
                                                .homeLikeUnlikeWB(
                                                  strGetUserId.toString(),
                                                  widget.getDataForComment[
                                                          'postId']
                                                      .toString(),
                                                  '2',
                                                )
                                                .then((value) => {
                                                      funcSendUserIdToGetHomeData(
                                                          strGetUserId
                                                              .toString(),
                                                          'no'),
                                                    });
                                      },
                                      icon: (widget
                                                  .getDataForComment['youliked']
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
                                      '${widget.getDataForComment['likesCount'].toString()} like 2',
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
                                        getDataForComment:
                                            widget.getDataForComment,
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
                      ),*/
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
                      if (strCommentsScreen == '0')
                        const CircularProgressIndicator()
                      else if (strCommentsScreen == '1')
                        textWithBoldStyle(
                          'No comments found',
                          Colors.black,
                          14.0,
                        )
                      else
                        Column(
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
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            image: (arrCommentList[i]
                                                            ['Userimage']
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
                                                      arrCommentList[i]
                                                              ['Userimage']
                                                          .toString(),
                                                    ),
                                                    fit: BoxFit.cover,
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
                                            arrCommentList[i]['fullName']
                                                .toString(),
                                            //
                                            Colors.black,
                                            16.0,
                                          ),
                                        ),
                                        //
                                        (arrCommentList[i]['userId']
                                                    .toString() ==
                                                strGetUserId)
                                            ? IconButton(
                                                onPressed: () {
                                                  //
                                                  deleteCommentPopup(
                                                      context,
                                                      arrCommentList[i]
                                                              ['postId']
                                                          .toString(),
                                                      arrCommentList[i]
                                                              ['commentId']
                                                          .toString());
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
                                        //
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                        ),
                      //
                      const SizedBox(
                        height: 80,
                      ),
                    ]
                    // ]

                    //
                  ],
                ],
              ),
            ),

            //

            //
            // ======> SEND MESSAGE UI <======
            // ===============================
            Align(
              alignment: Alignment.bottomCenter,
              child: sendMessageUI(),
            ),
            // ================================
            // ================================
            //
            //
          ],
          //
        ),
      ),
    );
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
            if (widget.getDataForComment['message'].toString() == '')
              ...[]
            else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.getDataForComment['message']..toString(),
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
                    if (widget.getDataForComment['share']['message']
                            .split(',')[2] ==
                        '')
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.getDataForComment['share']['message']
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
                            double.parse(widget.getDataForComment['share']
                                    ['message']
                                .split(',')[0]),
                            double.parse(widget.getDataForComment['share']
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
              widget.getDataForComment['userId'].toString()) ...[
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
                image: (widget.getDataForComment['share']['userImage']
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
                          widget.getDataForComment['share']['userImage']
                              .toString(),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
              ),
            )
            //
          ] else if (widget.getDataForComment['friendStatus'].toString() ==
                  '0' ||
              widget.getDataForComment['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (widget.getDataForComment['SettingProfilePicture'].toString() ==
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
                  image: (widget.getDataForComment['share']['userImage']
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
                            widget.getDataForComment['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
          ] else if (widget.getDataForComment['friendStatus'].toString() ==
              '2') ...[
            // THEY BOTH ARE FRIENDS
            if (widget.getDataForComment['SettingProfilePicture'].toString() ==
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
                  image: (widget.getDataForComment['share']['userImage']
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
                            widget.getDataForComment['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
                  image: (widget.getDataForComment['share']['userImage']
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
                            widget.getDataForComment['share']['userImage']
                                .toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(
                          strUserId:
                              widget.getDataForComment['userId'].toString(),
                        ),
                      ),
                    );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: widget.getDataForComment['share']['userName']
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
                              widget.getDataForComment['share']['created']
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

  void _onMapCreated(GoogleMapController controller) {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        widget.getDataForComment['share']['message'].split(',')[0],
        widget.getDataForComment['share']['message'].split(',')[1],
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
                                fit: BoxFit.cover,
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

  /*Column commentsUI(BuildContext context) {
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
                        image:
                            (widget.getDataForComment['Userimage'].toString() ==
                                    '')
                                ? const DecorationImage(
                                    image: AssetImage(
                                      'assets/icons/avatar.png',
                                    ),
                                    fit: BoxFit.fitHeight,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                      widget.getDataForComment['Userimage']
                                          .toString(),
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
                    textWithBoldStyle(
                      //
                      arrCommentList[i]['fullName'].toString(),
                      //
                      Colors.black,
                      16.0,
                    ),
                    //
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
  }*/

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
                    image: (widget.getDataForComment['Userimage'].toString() ==
                            '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              widget.getDataForComment['Userimage'].toString(),
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
                                strUserId: widget.getDataForComment['userId']
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
                                widget.getDataForComment['fullName'].toString(),
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
                                    widget.getDataForComment['created']
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
                (strGetUserId.toString() ==
                        widget.getDataForComment['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   widget.getDataForComment['postId'].toString(),
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
          if (widget.getDataForComment['message'].toString() != '') ...[
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
                widget.getDataForComment['message'].toString(),
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
                            // print(widget.getDataForComment['share']);
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
                              image: (widget.getDataForComment['share']
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
                                        widget.getDataForComment['share']
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyProfileScreen(
                                        strUserId: widget
                                            .getDataForComment['userId']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                  //
                                },
                                child: RichText(
                                  text: TextSpan(
                                    //
                                    text: widget.getDataForComment['share']
                                            ['userName']
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
                                            widget.getDataForComment['created']
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
                      widget.getDataForComment['share']['message'].toString(),
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
          //     widget.getDataForComment['message'].toString(),
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
                InkWell(
                  onTap: () {
                    // print(widget.getDataForComment['share']);
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
                      image:
                          (widget.getDataForComment['Userimage'].toString() ==
                                  '')
                              ? const DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/avatar.png',
                                  ),
                                  fit: BoxFit.fitHeight,
                                )
                              : DecorationImage(
                                  image: NetworkImage(
                                    widget.getDataForComment['Userimage']
                                        .toString(),
                                  ),
                                  fit: BoxFit.fitHeight,
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
                                strUserId: widget.getDataForComment['userId']
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
                                widget.getDataForComment['fullName'].toString(),
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
                                    widget.getDataForComment['created']
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
                (strGetUserId.toString() ==
                        widget.getDataForComment['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   widget.getDataForComment['postId'].toString(),
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
              widget.getDataForComment['message'].toString(),
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
  Container sendMessageUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromRGBO(
        246,
        248,
        253,
        1,
      ),
      // height: 60,
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contComment,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  // labelText: '',
                  hintText: 'write something',
                ),
              ),
            ),
          ),
          //

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: () {
                  //

                  addCommentWB();
                  //
                },
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ),
          ),
          /*IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('send');
              }
              //

              sendMessageViaFirebase(contTextSendMessage.text);
              lastMessage = contTextSendMessage.text.toString();
              contTextSendMessage.text = '';

              // }
            },
            icon: const Icon(
              Icons.send,
            ),
          ),*/
          //
        ],
      ),
    );
  }

  //
  getGrindWB() async {
    if (kDebugMode) {
      print('=====> POST : COMMENTS LIST');
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
          'postId': widget.getDataForComment['postId'].toString(),
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
        setState(() {});
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
  addCommentWB() async {
    if (kDebugMode) {
      print('=====> POST : ADD COMMENT');
    }

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      strCommentsScreen = '0';
    });

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
          'action': 'addcomment',
          'userId': strGetUserId.toString(),
          'postId': widget.getDataForComment['postId'].toString(),
          'comment': contComment.text.toString(),
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
        contComment.text = '';
        getGrindWB();
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
  funcPlayVideo(videoURL) {
    _controller2 = VideoPlayerController.network(
      videoURL,
    );

    _initializeVideoPlayerFuture2 = _controller2!.initialize();
    // _controller2.play();
    setState(() {
      strListVideoPlay = '1';
    });
  }

  funcSendUserIdToGetHomeData(
    strLoginUserId,
    strBack,
  ) {
    getGrindWB();
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
        getGrindWB();
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
        getGrindWB();
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

  Container shardImageDataUI(BuildContext context) {
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
                    image: (widget.getDataForComment['share']['userImage']
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
                              widget.getDataForComment['share']['userImage']
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
                                strUserId: widget.getDataForComment['share']
                                        ['userId']
                                    .toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: widget.getDataForComment['share']['userName']
                                .toString(),
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
                                    widget.getDataForComment['created']
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

          if (widget.getDataForComment['message'].toString() == '')
            ...[]
          else ...[
            if (widget.getDataForComment['share']['message'].toString() == '')
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
                  widget.getDataForComment['share']['message'].toString(),
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
                itemCount:
                    widget.getDataForComment['share']['postImage'].length,
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
                            widget.getDataForComment['share']['postImage']
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
                              '$currentIndex / ${widget.getDataForComment['share']['postImage'].length}',
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
                        print(widget.getDataForComment['youliked'].toString());
                        print(widget.getDataForComment['postId'].toString());
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

                      (widget.getDataForComment['youliked'].toString() == 'No')
                          ? homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                widget.getDataForComment['postId'].toString(),
                                '1',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                        strGetUserId.toString(), 'no'),
                                  })
                          : homeLikeUnlikeApiCall
                              .homeLikeUnlikeWB(
                                strGetUserId.toString(),
                                widget.getDataForComment['postId'].toString(),
                                '2',
                              )
                              .then((value) => {
                                    funcSendUserIdToGetHomeData(
                                        strGetUserId.toString(), 'no'),
                                  });
                    },
                    icon: (widget.getDataForComment['youliked'].toString() ==
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
                    '${widget.getDataForComment['likesCount'].toString()} like 3',
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
                      getDataForComment: widget.getDataForComment,
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

  Container deletePostWB(BuildContext context) {
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
                    image: (widget.getDataForComment['Userimage'].toString() ==
                            '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              widget.getDataForComment['Userimage'].toString(),
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
                                strUserId: widget.getDataForComment['userId']
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
                                widget.getDataForComment['fullName'].toString(),
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
                                    widget.getDataForComment['created']
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
                (strGetUserId.toString() ==
                        widget.getDataForComment['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('open action sheet');
                          }
                          //
                          // deletePostFromMenu(
                          //   context,
                          //   widget.getDataForComment['postId'].toString(),
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
                          // print(widget.getDataForComment);
                          blockUserPostFromMenu(context,
                              widget.getDataForComment['userId'].toString());
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
              widget.getDataForComment['message'].toString(),
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
  Container locationNotSharedHeaderUI(
    BuildContext context,
  ) {
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
              widget.getDataForComment['userId'].toString()) ...[
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
                image: (widget.getDataForComment['Userimage'].toString() == '')
                    ? const DecorationImage(
                        image: AssetImage(
                          'assets/icons/avatar.png',
                        ),
                        fit: BoxFit.fitHeight,
                      )
                    : DecorationImage(
                        image: NetworkImage(
                          widget.getDataForComment['Userimage'].toString(),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
              ),
            ),

            //
          ] else if (widget.getDataForComment['friendStatus'].toString() ==
                  '0' ||
              widget.getDataForComment['friendStatus'].toString() == '1') ...[
            // 0 = no friend
            if (widget.getDataForComment['SettingProfilePicture'].toString() ==
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
                  image: (widget.getDataForComment['Userimage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            widget.getDataForComment['Userimage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
          ] else if (widget.getDataForComment['friendStatus'].toString() ==
              '2') ...[
            // THEY BOTH ARE FRIENDS
            if (widget.getDataForComment['SettingProfilePicture'].toString() ==
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
                  image: (widget.getDataForComment['Userimage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            widget.getDataForComment['Userimage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
                  image: (widget.getDataForComment['Userimage'].toString() ==
                          '')
                      ? const DecorationImage(
                          image: AssetImage(
                            'assets/icons/avatar.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            widget.getDataForComment['Userimage'].toString(),
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                ),
              )
              //
            ] else if (widget.getDataForComment['SettingProfilePicture']
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(
                          strUserId:
                              widget.getDataForComment['userId'].toString(),
                        ),
                      ),
                    );
                    //
                  },
                  child: RichText(
                    text: TextSpan(
                      //
                      text: widget.getDataForComment['fullName'].toString(),
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
                              widget.getDataForComment['created'].toString(),
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
  }
}
