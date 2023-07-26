import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
import 'package:pludin/classes/header/utils.dart';

import 'package:readmore/readmore.dart';

class HomeFeedsTextUIScreen extends StatefulWidget {
  const HomeFeedsTextUIScreen({super.key, this.getData, this.strLoginUserId});

  final strLoginUserId;
  final getData;

  @override
  State<HomeFeedsTextUIScreen> createState() => _HomeFeedsTextUIScreenState();
}

class _HomeFeedsTextUIScreenState extends State<HomeFeedsTextUIScreen> {
  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('dishu 2.0');

      print(widget.getData);
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
                    color: Colors.transparent,
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
                                strUserId: widget.getData['userId'].toString(),
                              ),
                            ),
                          );
                          //
                        },
                        child: RichText(
                          text: TextSpan(
                            //
                            text: widget.getData['fullName'].toString(),
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
                (widget.strLoginUserId.toString() ==
                        widget.getData['userId'].toString())
                    ? IconButton(
                        onPressed: () {
                          print('open action sheet');
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
              widget.getData['message'].toString(),
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
}
