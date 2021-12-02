import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:get/get.dart';
import 'Config/themes.dart';
import 'Services/Controllers/auth_controller.dart';

// ignore: must_be_immutable
class OurApp extends StatelessWidget {
  OurApp({Key? key}) : super(key: key);

  static const String _USERS = "users";
  static const String _EMAIL = "email";

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();
  bool isGovern = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2210),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Themes().lightTheme,
        home: firebaseHelper.auth.currentUser != null
            ? const HomePage()
            : const OnBoarding(),
      ),
    );
  }
}
