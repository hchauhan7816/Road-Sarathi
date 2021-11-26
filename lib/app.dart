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
      // Todo Adjust according to your phone resolution before work
      designSize: const Size(1080, 2210),
      builder: () => GetMaterialApp(
        title: 'Flutter Demo',
        theme: Themes().lightTheme,

        // Todo uncomment
        // home:
        //     firebaseHelper.auth.currentUser != null ? HomePage() : OnBoarding(),

        home: SplashScreen(),

        // home: Temp(), //MyMap(), // Temp(),

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

  // bool isGovernment() {
  //   int? x;
  //   firebaseHelper.firebaseFirestore
  //       .collection(OurApp._USERS)
  //       .where(OurApp._EMAIL, isEqualTo: Constants.myEmail)
  //       .get()
  //       .then((value) {
  //     value.docs.isNotEmpty ? x = value.docs[0].data()["status"] : x = null;
  //   });

  //   //   dev.log(value.docs[0].data()["status"].toString());
  //   // });

  //   dev.log("Here");
  //   dev.log(x.toString());

  //   if (x != null) {
  //     dev.log(x.toString());
  //     if (x != 0) {
  //       return true;
  //       // Get.offAll(
  //       // () => GovConversationRooms(authorityEmail: _HIGHERAUTHORITYMAIL));

  //     }
  //   }

  //   dev.log("Here");
  //   return false;
  // }
}
