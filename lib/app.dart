import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/Login%20Signup%20Page/login_gov.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:get/get.dart';

import 'Config/themes.dart';
import 'Pages/Chat Screen/chat_screen.dart';
import 'Pages/Conversation Rooms/conversation_rooms.dart';
import 'Pages/Login Signup Page/login.dart';
import 'Pages/Signup Page/signup.dart';
import 'Services/Controllers/auth_controller.dart';

class OurApp extends StatelessWidget {
  OurApp({Key? key}) : super(key: key);

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Todo Adjust according to your phone resolution before work
      designSize: const Size(1080, 2210),
      builder: () => GetMaterialApp(
        title: 'Flutter Demo',
        theme: Themes().lightTheme,
        // Todo navigate to which home page (user or gov)?

        // home: firebaseHelper.auth.currentUser != null
        //     ? GovConversationRooms(
        //         authorityEmail: "localauthority@gmail.com") //HomePage()
        //     : const OnBoarding(),

        // Todo update the path to home page back
        home: OnBoarding(),

        // getPages: [
        //   GetPage(name: '/on_boarding', page: () => const OnBoarding()),
        //   GetPage(name: '/login', page: () => const LoginPage()),
        //   GetPage(name: '/signup', page: () => const SignupPage()),
        //   GetPage(name: '/gov_login', page: () => const LoginGovPage()),
        //   GetPage(name: '/home', page: () => HomePage()),
        //   GetPage(name: '/convRoom', page: () => ConversationRooms()),
        // ],
      ),
    );
  }
}
