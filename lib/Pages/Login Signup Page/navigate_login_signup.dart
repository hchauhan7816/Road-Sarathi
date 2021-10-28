import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Widgets/text_styles.dart';

class LoginNavigator extends StatelessWidget {
  const LoginNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: LoginNavigatorBody(), appBar: null);
  }
}

class LoginNavigatorBody extends StatelessWidget {
  const LoginNavigatorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // Standard Value of top Padding 80.h in case of NO APP BAR
        padding: EdgeInsets.only(top: 80.h, left: 40.w, right: 40.w),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 125.h,
            ),
            Text(
              "Welcome",
              style: heading1(),
            ),
            SizedBox(
              height: 70.h,
            ),
            Text(
              "Seamless expierience by govt to provide the bad conditioned road reporting",
              style: small1(),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Container(
              height: 800.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/welcome.png"),
                ),
              ),
            ),
            Spacer(),
            buttons(context),
            SizedBox(height: 150.h),
          ],
        ),
      ),
    );
  }

  Widget buttons(context) => Column(
        children: [
          MaterialButton(
            minWidth: double.infinity,
            height: 150.h,
            onPressed: () {
              Get.toNamed("/login");
            },
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(75.w),
            ),
            child: Text(
              "Login",
              style: normal2(),
            ),
          ),
          SizedBox(
            height: 60.h,
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 150.h,
            onPressed: () {
              Get.toNamed("/gov_login");
            },
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(75.w),
            ),
            child: Text(
              "Login as Government",
              style: normal2(),
            ),
          ),
          SizedBox(
            height: 60.h,
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 150.h,
            onPressed: () {
              Get.toNamed("/signup");
            },
            color: Palette.darkPurple,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Palette.darkPurple),
              borderRadius: BorderRadius.circular(75.w),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 55.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
