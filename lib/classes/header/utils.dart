// text with regular
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/* ================================================================ */

var applicationBaseURL =
    'https://demo4.evirtualservices.net/pludin/services/index';

/* ================================================================ */

/* ==================== LOCAL DATABASE ============================= */
var notificationServerKey =
    'AAAAAdo_SA8:APA91bHyWGpMlN1x9WXIAD31RmcWArl1a8rABTQI4lCMeQXtQGFuFw2eMMpOnXNfvCUWzSvQpkvJcb3JkWfublJZRVr181BhA2ZiJ4O7OWDpoGyAZtkoLhMJseGCvII9JMnOHOSgjXJw';
/* ================================================================ */

/* ==================== LOCAL DATABASE ============================= */

var databaseTableName = 'test3';

/* ========================FIREBASE MODE ======================== */ //
// test mode
var strFirebaseMode = 'mode/test/';
/* ================================================================ */

var appId = 'bbe938fe04a746fd9019971106fa51ff';

/* ========================FIREBASE MODE ======================== */ //

var navigationColor = const Color.fromRGBO(213, 49, 63, 1);
var appBlueColor = const Color.fromRGBO(57, 49, 157, 1);

var navigationTitleGetStarted = 'Get Started Now';
var navigationTitleLogin = 'Login';
var navigationTitleSignUp = 'Create an account';
var navigationTitleGeneralSettings = 'General Settings';
var navigationTitleBlockedFriends = 'Blocked Friends';
var navigationTitlePrivacyScreen = 'Privacy Settings';
var navigationTitleNotificationScreen = 'Notification Settings';
var navigationTitleEmailScreen = 'Email Settings';

/* ================================================================ */

Text textWithRegularStyle(str, color, size) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      color: color,
      fontSize: size,
    ),
  );
}

// text with bold
Text textWithBoldStyle(str, color, size) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );
}

/* ================================================================ */
/* ========== CONVERT TIMESTAMP TO DATE AND TIME =============== */

funcConvertTimeStampToDateAndTime(getTimeStamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(getTimeStamp);
  // var d12HourFormat = DateFormat('dd/MM/yyyy, hh:mm').format(dt);
  var d12HourFormatTime = DateFormat('hh:mm a').format(dt);
  return d12HourFormatTime;
}

/* ================================================================ */
/* ================================================================ */

void showLoadingUI(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textWithRegularStyle(
                    //
                    message,
                    //
                    Colors.black,
                    14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  //
}

//
void callEnded(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textWithRegularStyle(
                    //
                    message,
                    //
                    Colors.black,
                    14.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: textWithBoldStyle(
                      'report this post ?',
                      Colors.redAccent,
                      18.0,
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 40,
              // ),
              // Flexible(
              //   child: Container(
              //     height: 40,
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.transparent,
              //     child: Center(
              //       child: textWithBoldStyle(
              //         'report',
              //         Colors.black,
              //         18.0,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      );
    },
  );
}

//
void showHomePopUp(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textWithRegularStyle(
                    //
                    message,
                    //
                    Colors.black,
                    14.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: textWithBoldStyle(
                      'report this post ?',
                      Colors.redAccent,
                      18.0,
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 40,
              // ),
              // Flexible(
              //   child: Container(
              //     height: 40,
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.transparent,
              //     child: Center(
              //       child: textWithBoldStyle(
              //         'report',
              //         Colors.black,
              //         18.0,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      );
    },
  );
}
