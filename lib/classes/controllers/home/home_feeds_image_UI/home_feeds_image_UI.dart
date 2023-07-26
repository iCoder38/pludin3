// import 'dart:convert';

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:pludin/classes/controllers/home/home_like_modal/home_like_modal.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
// import 'package:pludin/classes/controllers/profile/my_profile_feeds/my_profile_feeds.dart';
import 'package:pludin/classes/header/utils.dart';

class HomeFeedsImageUIScreen extends StatefulWidget {
  const HomeFeedsImageUIScreen(
      {super.key, this.getData, required this.strTitle});

  final String strTitle;
  final getData;

  @override
  State<HomeFeedsImageUIScreen> createState() => _HomeFeedsImageUIScreenState();
}

class _HomeFeedsImageUIScreenState extends State<HomeFeedsImageUIScreen> {
  //

  //
  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('dishu 2.0');

      // print(widget.getData);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    image: (widget.getData['Userimage'].toString() == '')
                        ? const DecorationImage(
                            image: AssetImage(
                              'assets/icons/avatar.png',
                            ),
                            fit: BoxFit.fitHeight,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                              widget.getData['Userimage'].toString(),
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
                          // Navigator.pushNamed(
                          //     context, 'push_to_profile_screen');

                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                strUserId: widget.getData['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                //
                                text: widget.getData['fullName'].toString(),
                                //
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Shared a new ${widget.strTitle}',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // child: widget
          ),
          //
          if (widget.getData['message'].toString() == '')
            const SizedBox(
              height: 0,
            )
          else
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: textWithRegularStyle(
                  //
                  widget.getData['message'].toString(),
                  //
                  Colors.black,
                  14.0,
                ),
              ),
            ),

          //
          // Container(
          //   height: 260,
          //   width: MediaQuery.of(context).size.width,
          //   color: Colors.transparent,
          //   child: PageView.builder(
          //     itemCount: widget.getData[i]['postImage'].length,
          //     pageSnapping: true,
          //     itemBuilder: (context, pagePosition) {
          //       return Container(
          //         margin: const EdgeInsets.all(1),
          //         child: Image.network(
          //           widget.getData[i]['postImage'][pagePosition]['name']
          //               .toString(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: 240,
          //   child: Image.network(
          //     //
          //     widget.getData['image'].toString(),
          //     //
          //     fit: BoxFit.cover,
          //     loadingBuilder: (BuildContext context, Widget child,
          //         ImageChunkEvent? loadingProgress) {
          //       if (loadingProgress == null) return child;
          //       return Center(
          //         child: CircularProgressIndicator(
          //           value: loadingProgress.expectedTotalBytes != null
          //               ? loadingProgress.cumulativeBytesLoaded /
          //                   loadingProgress.expectedTotalBytes!
          //               : null,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          //

          //
        ],
      ),
    );
  }
}
