import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/header/utils.dart';

class AppBarScreen extends StatelessWidget implements PreferredSizeWidget {
  final String navigationTitle;
  final String backClick;
  @override
  final Size preferredSize;

  AppBarScreen(
      {Key? key, required this.navigationTitle, required this.backClick})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (backClick == '0') {
      return AppBar(
        title: textWithRegularStyle(
          navigationTitle,
          Colors.white,
          20.0,
        ),
        backgroundColor: navigationColor,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        automaticallyImplyLeading: false,
      );
    } else if (backClick == '1') {
      return AppBar(
        title: textWithRegularStyle(
          navigationTitle,
          Colors.white,
          20.0,
        ),
        backgroundColor: navigationColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
      );
    } else {
      return AppBar(
        title: textWithRegularStyle(
          navigationTitle,
          Colors.white,
          20.0,
        ),
        backgroundColor: navigationColor,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('object');
              }
            },
            icon: const Icon(
              Icons.notifications,
            ),
          )
        ],
        automaticallyImplyLeading: true,
      );
    }
  }
}
