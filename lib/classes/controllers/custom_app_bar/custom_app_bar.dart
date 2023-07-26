import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/header/utils.dart';

class CustomAppBarScreen extends StatefulWidget {
  const CustomAppBarScreen(
      {super.key,
      this.getScaffold,
      required this.strForMenu,
      required this.strTextOrImage});

  final String strForMenu;
  final String strTextOrImage;
  final getScaffold;

  @override
  State<CustomAppBarScreen> createState() => _CustomAppBarScreenState();
}

class _CustomAppBarScreenState extends State<CustomAppBarScreen> {
  //

  //override
  @override
  Widget build(BuildContext context) {
    return Container(
      color: navigationColor,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              onPressed: () => widget.getScaffold.currentState!.openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
          //
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (widget.strTextOrImage == '0')
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      )
                    : textWithBoldStyle(
                        //
                        widget.strTextOrImage,
                        //
                        Colors.white,
                        20.0,
                      ),
              ),
            ),
          ),
          //
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('menu click');
                }
              },
              icon: const Icon(
                Icons.notifications_sharp,
                color: Colors.white,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }
}
