import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:pludin/classes/header/utils.dart';

class ProfileVideosScreen extends StatefulWidget {
  const ProfileVideosScreen({super.key, this.sendData});

  final sendData;

  @override
  State<ProfileVideosScreen> createState() => _ProfileVideosScreenState();
}

class _ProfileVideosScreenState extends State<ProfileVideosScreen> {
  //
  var strListVideoPlay = '0';
  late VideoPlayerController _controller2;
  late Future<void> _initializeVideoPlayerFuture2;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('dishant rajput');
      print(widget.sendData);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return /*InkWell(
      onTap: () {
        if (kDebugMode) {
          // print(sendData['postImage'][0]['name']);
        }
        funcPlayVideo(widget.sendData['image']);
        // _controller2.play();
        //
        /*
                     */
        showGeneralDialog(
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Center(
                              child: AspectRatio(
                                aspectRatio: _controller2.value.aspectRatio,
                                // width: MediaQuery.of(context)
                                // .size
                                // .width -
                                // 10,
                                //  height:
                                // 360,
                                child: Stack(
                                  children: [
                                    VideoPlayer(
                                      _controller2,
                                    ),
                                    //
                                    (strListVideoPlay == '1')
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
                                            height: 10,
                                          )
                                  ],
                                ),
                                
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
      child: Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: 220,
        // child: VideoPlayer(_controller2),
      ),
    );*/
        GridView.builder(
      padding: const EdgeInsets.all(6),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // maxCrossAxisExtent: 300,
        childAspectRatio: 6 / 6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15, crossAxisCount: 3,
      ),
      itemCount: widget.sendData.length,
      itemBuilder: (BuildContext ctx, index) {
        return InkWell(
          onTap: () {
            if (kDebugMode) {
              print('object');
            }

            print(widget.sendData[index]['image']);

            //
            funcPlayVideo(widget.sendData[index]['image']);
            //
            showGeneralDialog(
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
                            print('object 2');
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
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller2.value.aspectRatio,
                                    // width: MediaQuery.of(context)
                                    // .size
                                    // .width -
                                    // 10,
                                    //  height:
                                    // 360,
                                    child: Stack(
                                      children: [
                                        VideoPlayer(
                                          _controller2,
                                        ),
                                        //
                                        (strListVideoPlay == '1')
                                            ? Center(
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
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
                                                height: 10,
                                              )
                                      ],
                                    ),
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
          child: Container(
            margin: const EdgeInsets.only(
                // left: 10.0,
                // right: 10,
                ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(
                15,
              ),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/images/logo.png',
                  // fit: BoxFit.fitWidth,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/icons/profile_video_color.png',
              ),
            ),
          ),
        );
      },
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
}
