import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';

AppBar chatScreenAppBar(BuildContext context,
    {required String userEmail, required String chatroomId}) {
  const String _LOCALAUTHORITYMAIL = "localauthority@gmail.com";
  const String _HIGHERAUTHORITYMAIL = "higherauthority@gmail.com";

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  return AppBar(
    elevation: 10,
    title: Text("Chat Screen"),
    centerTitle: true,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      iconSize: 20,
      color: Colors.black,
    ),
    actions: [
      userEmail == _LOCALAUTHORITYMAIL || userEmail == _HIGHERAUTHORITYMAIL
          ? Padding(
              padding: EdgeInsets.all(5),
              child: MaterialButton(
                color: Colors.amber,
                onPressed: () {
                  firebaseHelper.setCompleteComplaint(chatroomId: chatroomId);
                },
                child: Text("Completed"),
              ),
            )
          : Container(),
    ],
  );
}
