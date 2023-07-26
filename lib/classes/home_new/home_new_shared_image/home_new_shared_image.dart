// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../../controllers/profile/profile_gallery/profile_gallery.dart';
import '../../header/utils.dart';

import 'package:timeago/timeago.dart' as timeago;

class HomeNewShareImageScreen extends StatefulWidget {
  const HomeNewShareImageScreen(
      {super.key, this.getDataSharedImageDataWithIndex});

  final getDataSharedImageDataWithIndex;

  @override
  State<HomeNewShareImageScreen> createState() =>
      _HomeNewShareImageScreenState();
}

class _HomeNewShareImageScreenState extends State<HomeNewShareImageScreen> {
  // for images
  late int currentIndex;
  var strImageCount = 0;
  List<String> arrScrollMultipleImages = [];
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 340, // if issue in height so make it static.
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            30.0,
          ),
          border: Border.all(
            width: 0.4,
          ),
        ),
        child: Column(
          children: [
            sharedImageHeaderUI(context),
            //
            //
            //
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  //
                  widget.getDataSharedImageDataWithIndex['share']['message']
                      .toString(),
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
            //
            // Text('data'),
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
                itemCount: widget
                    .getDataSharedImageDataWithIndex['share']['postImage']
                    .length,
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
                          funcOpenImage(pagePosition,
                              widget.getDataSharedImageDataWithIndex);
                          //
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          // height: 240,
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
                              widget.getDataSharedImageDataWithIndex['share']
                                  ['postImage'][pagePosition]['name'],
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
                              '$currentIndex / ${widget.getDataSharedImageDataWithIndex['share']['postImage'].length}',
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
          ],
        ),
      ),
    );
  }

  Container sharedImageHeaderUI(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        children: [
          if (widget.getDataSharedImageDataWithIndex['share']['userImage']
                  .toString() ==
              '')
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
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: Image.network(
                    //
                    widget.getDataSharedImageDataWithIndex['share']['userImage']
                        .toString(),
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
                            text: widget
                                .getDataSharedImageDataWithIndex['share']
                                    ['userName']
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
                            text: ' shared some image'.toString(),
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
                          widget.getDataSharedImageDataWithIndex['share']
                                  ['created']
                              .toString(),
                        ),
                      ),
                      Colors.black,
                      14.0,
                    ),
                  ),
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
  //
  funcOpenImage(pagePosition, i) {
    for (int j = 0;
        j < widget.getDataSharedImageDataWithIndex['share']['postImage'].length;
        j++) {
      arrScrollMultipleImages.add(widget
          .getDataSharedImageDataWithIndex['share']['postImage'][j]['name']);
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
}
