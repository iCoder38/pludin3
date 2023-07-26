import 'package:flutter/material.dart';

class SplashCenterLogo extends StatelessWidget {
  const SplashCenterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(
          10.0,
        ),
        width: MediaQuery.of(context).size.width / 2.4,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(
              'assets/images/logo.png',
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        //child: widget,
      ),
    );
  }
}
