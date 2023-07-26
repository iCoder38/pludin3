// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../../controllers/profile/profile_gallery/profile_gallery.dart';
import '../../header/utils.dart';

class HomeNewImageScreen extends StatefulWidget {
  const HomeNewImageScreen({super.key, this.getDataForImageWithIndex});

  final getDataForImageWithIndex;

  @override
  State<HomeNewImageScreen> createState() => _HomeNewImageScreenState();
}

class _HomeNewImageScreenState extends State<HomeNewImageScreen> {
  //
  // for images
  late int currentIndex;
  var strImageCount = 0;
  List<String> arrScrollMultipleImages = [];
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (widget.getDataForImageWithIndex['message'].toString() == '')
            ? const SizedBox(
                height: 0,
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ReadMoreText(
                    //
                    widget.getDataForImageWithIndex['message'].toString(),
                    //"widget.getDataForImageWithIndex['message'].toString()",
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
            itemCount: widget.getDataForImageWithIndex['postImage'].length,
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
                      funcOpenImage(
                          pagePosition, widget.getDataForImageWithIndex);
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
                          widget.getDataForImageWithIndex['postImage']
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
                          '$currentIndex / ${widget.getDataForImageWithIndex['postImage'].length}',
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
    );
  }

  //
  //
  funcOpenImage(pagePosition, i) {
    for (int j = 0;
        j < widget.getDataForImageWithIndex['postImage'].length;
        j++) {
      arrScrollMultipleImages
          .add(widget.getDataForImageWithIndex['postImage'][j]['name']);
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
