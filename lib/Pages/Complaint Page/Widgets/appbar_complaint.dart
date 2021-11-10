import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';

AppBar complaintPageAppBar(BuildContext context) {
  return AppBar(
    // elevation: 10,
    title: Text(
      "Register Complaint",
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
