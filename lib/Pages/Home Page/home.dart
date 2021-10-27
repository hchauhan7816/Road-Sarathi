import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: MaterialButton(
            minWidth: double.infinity,
            height: 150.h,
            onPressed: () {
              authController.signout();
            },
            color: Palette.darkPurple,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Palette.darkPurple),
              borderRadius: BorderRadius.circular(75.w),
            ),
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 55.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
