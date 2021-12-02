import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';

AppBar complaintPageAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      "Register Complaint",
      style: appTitleStyle,
    ),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          Get.offAll(() => const OnBoarding());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.logout),
        ),
      ),
    ],
  );
}
