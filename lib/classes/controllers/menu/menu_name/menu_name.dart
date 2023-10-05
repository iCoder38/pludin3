import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/controllers/profile/my_profile.dart';
import 'package:pludin/classes/header/utils.dart';

class MenuNameScreen extends StatefulWidget {
  const MenuNameScreen(
      {super.key,
      required this.strloginUserName,
      required this.strloginUserId,
      required this.strloginProfileName});

  final String strloginUserName;
  final String strloginUserId;
  final String strloginProfileName;

  @override
  State<MenuNameScreen> createState() => _MenuNameScreenState();
}

class _MenuNameScreenState extends State<MenuNameScreen> {
  @override
  void initState() {
    if (kDebugMode) {
      print('login user id ====> ${widget.strloginUserId}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              //
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfileScreen(
                    strUserId: widget.strloginUserId,
                  ),
                ),
              );
              //
            },
            child: Container(
              margin: const EdgeInsets.only(left: 0.0),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                  fit: BoxFit.cover,
                ),
                color: Colors.pink[600],
                borderRadius: BorderRadius.circular(
                  27.0,
                ),
              ),
            ),
          ),
          //
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: textWithBoldStyle(
                      //
                      widget.strloginUserName.toString(),
                      //
                      Colors.white,
                      18.0,
                    ),
                  ),
                ),
                //
                Align(
                  alignment: Alignment.centerLeft,
                  child: textWithRegularStyle(
                    //
                    ' @${widget.strloginUserName}',
                    //
                    const Color.fromRGBO(
                      112,
                      209,
                      214,
                      1,
                    ),
                    14.0,
                  ),
                ),
                //
              ],
            ),
          ),
          //
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('click cross');
              }
              //
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
