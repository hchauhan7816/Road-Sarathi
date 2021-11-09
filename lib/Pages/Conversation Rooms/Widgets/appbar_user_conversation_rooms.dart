import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';

AppBar userConversationRoomsAppBar(BuildContext context, {TabBar? tabBar}) {
  return AppBar(
    // elevation: 10,
    title: Text(
      "Chat Rooms",
      style: appTitleStyle,
    ),
    centerTitle: true,
    // brightness: Brightness.light,
    // backgroundColor: Colors.white,
    bottom: tabBar,
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
