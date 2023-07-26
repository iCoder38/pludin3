// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../header/utils.dart';
import '../home_new_play_video/home_new_play_video.dart';

import 'package:timeago/timeago.dart' as timeago;

class HomeNewSharedVideoScreen extends StatefulWidget {
  const HomeNewSharedVideoScreen({super.key, this.getDataForVideoWithIndex});

  final getDataForVideoWithIndex;

  @override
  State<HomeNewSharedVideoScreen> createState() =>
      _HomeNewSharedVideoScreenState();
}

class _HomeNewSharedVideoScreenState extends State<HomeNewSharedVideoScreen> {
  //
  var strPlayPause = '0';
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
          border: Border.all(
            width: 0.4,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (widget.getDataForVideoWithIndex['share']['userImage']
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
                        color: Colors.amber,
                        child: Image.network(
                          //
                          widget.getDataForVideoWithIndex['share']['userImage']
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
                                  text: widget.getDataForVideoWithIndex['share']
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
                                  text: ' shared some video'.toString(),
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
                                widget.getDataForVideoWithIndex['share']
                                        ['created']
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
              ],
            ),
            //
            //
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  //
                  widget.getDataForVideoWithIndex['share']['message']
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
                  widget.getDataForVideoWithIndex['share']['postImage'][0]
                          ['name']
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
                                          getURL: widget
                                              .getDataForVideoWithIndex['share']
                                                  ['postImage'][0]['name']
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
          ],
        ),
      ),
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
}
