import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Controllers/auth_controller.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/Login%20Signup%20Page/login_gov.dart';
import 'package:sadak/Pages/Login%20Signup%20Page/navigate_login_signup.dart';
import 'package:get/get.dart';

import 'Pages/Login Signup Page/login.dart';
import 'Pages/Login Signup Page/signup.dart';

class OurApp extends StatelessWidget {
  OurApp({Key? key}) : super(key: key);

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Todo Adjust according to your phone resolution before work
      designSize: const Size(1080, 2210),
      builder: () => GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Todo navigate to which home page?
        home: authController.auth.currentUser != null
            ? HomePage()
            : const LoginNavigator(),
        getPages: [
          GetPage(name: '/navigator', page: () => const LoginNavigator()),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/signup', page: () => const SignupPage()),
          GetPage(name: '/gov_login', page: () => const LoginGovPage()),
          GetPage(name: '/home', page: () => HomePage()),
        ],
      ),
    );
  }
}
