import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';

AppBar chatScreenAppBar(BuildContext context,
    {required String userEmail, required String chatroomId}) {
  const String _LOCALAUTHORITYMAIL = "localauthority@gmail.com";
  const String _HIGHERAUTHORITYMAIL = "higherauthority@gmail.com";

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  return AppBar(
    elevation: 0,
    toolbarHeight: 60,
    title: Text(
      "Chat Screen",
      style: appTitleStyle,
    ),
    centerTitle: true,
    // brightness: Brightness.light,
    // backgroundColor: Colors.white,
    // leading: IconButton(
    //   onPressed: () {
    //     Get.back();
    //   },
    //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
    //   iconSize: 20,
    //   color: Colors.black,
    // ),
    actions: [
      userEmail == _LOCALAUTHORITYMAIL || userEmail == _HIGHERAUTHORITYMAIL
          ? Padding(
              padding: EdgeInsets.all(5),
              // child: MaterialButton(
              //   color: Colors.amber,
              //   onPressed: () {
              //     firebaseHelper.setCompleteComplaint(chatroomId: chatroomId);
              //   },

              child: Container(
                height: 40,
                width: 100,
                constraints: BoxConstraints(maxWidth: 100),
                alignment: Alignment.center,
                child: Text(
                  "Mark Done",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  color: Palette.orange, //Colors.amber,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              // child: Text(
              //   "Completed",
              //   style: TextStyle(fontSize: 15),
              // ),
              // ),
            )
          : Container(),
    ],
  );
}
