import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:get/get.dart';
import 'package:sadak/Pages/Slider/splash_screen.dart';
import 'package:sadak/Pages/temp.dart';
import 'package:sadak/Pages/temp2.dart';
import 'Config/themes.dart';
import 'Pages/Chat Screen/chat_screen.dart';
import 'Pages/Conversation Rooms/conversation_rooms.dart';
import 'Pages/Signup Page/signup.dart';
import 'Services/Controllers/auth_controller.dart';
import 'dart:developer' as dev;

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
        home:
            firebaseHelper.auth.currentUser != null ? HomePage() : OnBoarding(),
      ),
    );
  }
}
