// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pludin/classes/header/utils.dart';
import 'package:readmore/readmore.dart';

import '../../controllers/database/database_helper.dart';

class HomeNewCommentsScreen extends StatefulWidget {
  const HomeNewCommentsScreen({super.key, this.getUserIdForComment});

  final getUserIdForComment;

  @override
  State<HomeNewCommentsScreen> createState() => _HomeNewCommentsScreenState();
}

class _HomeNewCommentsScreenState extends State<HomeNewCommentsScreen> {
  //
  late DataBase handler;
  var strGetUserId = '';
  var strImage = '';
  var arrCommentList = [];
  TextEditingController contTextSendMessage = TextEditingController();
  //
  var strEditComment = '0';
  var strSavePostIdToEditComment = '0';
  var strSaveCommentIdToEditComment = '0';
  //
  @override
  void initState() {
    //
    if (kDebugMode) {
      print('post id is =====>' + widget.getUserIdForComment);
    }
    handler = DataBase();
    funcGetLocalDBdata();
    super.initState();
  }

  //
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
                    // print(value[i].fullName),
                    strGetUserId = value[i].userId.toString(),
                    strImage = value[i].image.toString(),
                    // print('dishant rajput'),
                    // print(strGetUserId),
                  },
                //
                getCommentListWB('yes'),
                //
              });
        }
      },
    );
    //
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: textWithBoldStyle(
            'Comments ( ${arrCommentList.length} )',
            Colors.white,
            16.0,
          ),
          backgroundColor: navigationColor,
        ),
        body: Stack(
          children: [
            ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: arrCommentList.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    leading: (arrCommentList[i]['Userimage'].toString() == '')
                        ? Image.asset('assets/icons/avatar.png')
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              30.0,
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Colors.amber,
                              child: Image.network(
                                //
                                arrCommentList[i]['Userimage'].toString(),
                                fit: BoxFit.cover,
                                //
                              ),
                            ),
                          ),
                    title: textWithBoldStyle(
                      //
                      arrCommentList[i]['fullName'].toString(),
                      //
                      Colors.black,
                      18.0,
                    ),
                    subtitle: ReadMoreText(
                      //
                      arrCommentList[i]['comment'].toString(),
                      //
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                      //
                      trimLines: 3,
                      colorClickableText: Colors.black,
                      lessStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '...Show more',
                      trimExpandedText: '...Show less',
                      moreStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing:
                        (strGetUserId == arrCommentList[i]['userId'].toString())
                            ? IconButton(
                                onPressed: () {
                                  //
                                  openGearCommentActionSheet(
                                      context,
                                      arrCommentList[i]['postId'].toString(),
                                      arrCommentList[i]['commentId'].toString(),
                                      arrCommentList[i]['comment'].toString());

                                  //
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                  );
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // height: 80,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (strEditComment == '1')
                            ? TextFormField(
                                autofocus: true,
                                controller: contTextSendMessage,
                                minLines: 1,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  // labelText: '',
                                  hintText: 'write comment',
                                ),
                              )
                            : TextFormField(
                                // autofocus: true,
                                controller: contTextSendMessage,
                                minLines: 1,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  // labelText: '',
                                  hintText: 'write comment',
                                ),
                              ),
                      ),
                    ),
                    //
                    IconButton(
                      onPressed: () {
                        //
                        (strEditComment == '0')
                            ? addCommentWB()
                            : editCommentWB();

                        //
                      },
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ) /*Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //
          const SizedBox(
            height: 10,
          ),
          //

          for (int i = 0; i < 4; i++) ...[
            Expanded(
              child: ListTile(
                title: Text('data'),
              ),
            )
          ],
          /*,*/
          //

          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
          )
        ],
      ),*/
        );
  }

  //
  //
  //
  getCommentListWB(show) async {
    if (kDebugMode) {
      print('=====> POST : COMMENTS LIST');
    }

    if (show == 'yes') {
      showLoadingUI(context, 'please wait...');
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'commentlist',
          'userId': '', //strGetUserId.toString(),
          'postId': widget.getUserIdForComment.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      // print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        arrCommentList.clear();
        //
        for (var i = 0; i < getData['data'].length; i++) {
          arrCommentList.add(getData['data'][i]);
        }
        //
        if (arrCommentList.isEmpty) {
          // strCommentsScreen = '1';
        } else {
          // strCommentsScreen = '2';
        }
        setState(() {
          Navigator.pop(context);
        });

        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  //
  addCommentWB() async {
    if (kDebugMode) {
      print('=====> POST : ADD COMMENT');
    }
    showLoadingUI(context, 'adding...');
    //
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'addcomment',
          'userId': strGetUserId.toString(),
          'postId': widget.getUserIdForComment.toString(),
          'comment': contTextSendMessage.text.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        contTextSendMessage.text = '';
        strEditComment = '0';
        getCommentListWB('no');
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  //
  //
  //
  editCommentWB() async {
    if (kDebugMode) {
      print('=====> POST : EDIT COMMENT');
    }
    showLoadingUI(context, 'updating...');
    //
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'addcomment',
          'userId': strGetUserId.toString(),
          'postId': strSavePostIdToEditComment.toString(),
          'comment': contTextSendMessage.text.toString(),
          'commentId': strSaveCommentIdToEditComment.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        contTextSendMessage.text = '';
        strEditComment = '0';
        getCommentListWB('no');
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  //
  void openGearCommentActionSheet(
      BuildContext context, getPostId, getCommentId, getComment) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Please select an option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              //
              //
              deleteCommentWB(
                getPostId.toString(),
                getCommentId.toString(),
              );
              //
            },
            child: textWithRegularStyle(
              'Delete Comment',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //
              //
              strEditComment = '1';
              contTextSendMessage.text = getComment.toString();
              strSavePostIdToEditComment = getPostId.toString();
              strSaveCommentIdToEditComment = getCommentId.toString();
              setState(() {});
              //
            },
            child: textWithRegularStyle(
              'Edit Comment',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.red,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  deleteCommentWB(strPostId, strCommentId) async {
    //
    showLoadingUI(context, 'deleting');
    //
    if (kDebugMode) {
      print('=====> POST : DELETE COMMENT ');
    }

    final resposne = await http.post(
      Uri.parse(
        applicationBaseURL,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'deletecomment',
          'userId': strGetUserId.toString(),
          'postId': strPostId.toString(),
          'commentId': strCommentId.toString(),
        },
      ),
    );

    // convert data to dict
    var getData = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(getData);
    }

    if (resposne.statusCode == 200) {
      if (getData['status'].toString().toLowerCase() == 'success') {
        //
        getCommentListWB('no');
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
    }
  }
  //
}
