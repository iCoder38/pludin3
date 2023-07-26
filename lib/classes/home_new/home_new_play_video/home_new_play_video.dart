import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../header/utils.dart';

import 'package:pod_player/pod_player.dart';

class HomeNewPlayVideoScreen extends StatefulWidget {
  const HomeNewPlayVideoScreen({super.key, required this.getURL});

  final String getURL;
  @override
  State<HomeNewPlayVideoScreen> createState() => _HomeNewPlayVideoScreenState();
}

class _HomeNewPlayVideoScreenState extends State<HomeNewPlayVideoScreen> {
  //
  late final PodPlayerController controller;
  // late VideoPlayerController _controller;
  // late Future<void> _initializeVideoPlayerFuture;
  //
  @override
  void initState() {
    super.initState();

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(widget.getURL.toString()),
    )..initialise();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Video',
          Colors.white,
          14.0,
        ),
        backgroundColor: navigationColor,
      ),
      body: PodVideoPlayer(
        controller: controller,
      ),
    );
  }
}
