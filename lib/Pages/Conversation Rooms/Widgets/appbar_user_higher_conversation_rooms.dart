import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';

AppBar userHigherConversationRoomsAppBar(BuildContext context,
    {TabBar? tabBar}) {
  return AppBar(
    elevation: 10,
    title: Text("Chat Room"),
    centerTitle: true,
    brightness: Brightness.light,
    bottom: tabBar,
    backgroundColor: Colors.white,
    actions: [
      GestureDetector(
        onTap: () {
          // authMethods.signOut();
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Authenticate(),
          //   ),
          // );
          Get.offAll(() => OnBoarding());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.logout),
        ),
      ),
    ],
  );
}
