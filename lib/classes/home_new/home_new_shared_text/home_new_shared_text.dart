// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../../header/utils.dart';

import 'package:timeago/timeago.dart' as timeago;

class HomeNewSharedTextScreen extends StatefulWidget {
  const HomeNewSharedTextScreen({super.key, this.getDataToShareTextWithIndex});

  final getDataToShareTextWithIndex;

  @override
  State<HomeNewSharedTextScreen> createState() =>
      _HomeNewSharedTextScreenState();
}

class _HomeNewSharedTextScreenState extends State<HomeNewSharedTextScreen> {
  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  //
                  widget.getDataToShareTextWithIndex['message'].toString(),
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
              // height: 40,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
                border: Border.all(
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          if (widget.getDataToShareTextWithIndex['share']
                                      ['userImage']
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
                                    widget.getDataToShareTextWithIndex['share']
                                            ['userImage']
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
                                                .getDataToShareTextWithIndex[
                                                    'share']['userName']
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
                                            text:
                                                ' shared some text'.toString(),
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
                                          widget.getDataToShareTextWithIndex[
                                                  'share']['created']
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: IconButton(
                          //     onPressed: () {
                          //       //
                          //       // showLoadingUI(context, 'please wait...');
                          //       //
                          //     },
                          //     icon: const Icon(
                          //       Icons.settings,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    //

                    Container(
                      // height: 140,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textWithRegularStyle(
                          //
                          widget.getDataToShareTextWithIndex['share']['message']
                              .toString(),
                          //
                          Colors.black,
                          14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //

            //
          ],
        ),
      ),
    );
  }
}
