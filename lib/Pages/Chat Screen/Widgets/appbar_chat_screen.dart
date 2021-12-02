import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';

AppBar chatScreenAppBar(BuildContext context,
    {required String userEmail,
    required String chatroomId,
    required bool completed}) {
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
    actions: [
      userEmail == _LOCALAUTHORITYMAIL || userEmail == _HIGHERAUTHORITYMAIL
          ? Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  if (!completed) {
                    firebaseHelper.setCompleteComplaint(chatroomId: chatroomId);
                  }
                },
                child: !completed
                    ? Container(
                        height: 40,
                        width: 100,
                        constraints: const BoxConstraints(maxWidth: 100),
                        alignment: Alignment.center,
                        child: const Text(
                          "Mark Done",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          color: Palette.orange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                    : Container(),
              ),
            )
          : Container(),
    ],
  );
}
