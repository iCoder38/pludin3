import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  //
  var strLoginUserId = '';
  late DataBase handler;
  //
  @override
  void initState() {
    super.initState();

    //
    handler = DataBase();
    funcGetLocalDBdata();
    //
  }

  funcGetLocalDBdata() {
    handler.retrievePlanets().then(
      (value) {
        // if (kDebugMode) {
        //   print(value);
        //   print(value.length);
        // }
        if (value.isEmpty) {
          if (kDebugMode) {
            print('NO, LOCAL DB DOES NOT HAVE ANY DATA');
          }
          // call firebase server
        } else {
          if (kDebugMode) {
            print('YES, LOCAL DB HAVE SOME DATA');
          }
          //

          handler.retrievePlanetsById(1).then((value) => {
                for (int i = 0; i < value.length; i++)
                  {
                    //
                    strLoginUserId = value[i].userId.toString(),
                    // print('dishant rajput 1.1 ====> $strLoginUserId'),
                    // print(widget.strUserId),
                    //
                  },
                //
                // HIT WEBSERVICE TO SEARCH FRIEND

                //
                //
              });
        }
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
