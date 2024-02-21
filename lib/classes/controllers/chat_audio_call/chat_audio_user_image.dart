import 'package:flutter/material.dart';
import 'package:pludin/classes/header/utils.dart';

class ChatAudioUserCenterScreen extends StatefulWidget {
  const ChatAudioUserCenterScreen({super.key});

  @override
  State<ChatAudioUserCenterScreen> createState() =>
      _ChatAudioUserCenterScreenState();
}

class _ChatAudioUserCenterScreenState extends State<ChatAudioUserCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 48.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),

            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                90.0,
              ),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/icons/avatar.png',
                ),
              ),
            ),
            // child: AboutDialog,
          ),
          //
          textWithBoldStyle(
            'Dishant Rajput',
            Colors.black,
            18.0,
          ),
        ],
      ),
    );
  }
}
