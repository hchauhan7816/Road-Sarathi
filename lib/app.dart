import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Config/constants.dart';
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
import 'dart:developer' as dev;

class OurApp extends StatefulWidget {
  OurApp({Key? key}) : super(key: key);

  static const String _USERS = "users";
  static const String _EMAIL = "email";

  @override
  State<OurApp> createState() => _OurAppState();
}

class _OurAppState extends State<OurApp> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();
  bool isGovern = false;

  @override
  void initState() {
    super.initState();

    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;
  }

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

        // home: firebaseHelper.auth.currentUser != null
        //     ? (isGovernment()
        //         ? GovConversationRooms(
        //             authorityEmail: "localauthority@gmail.com")
        //         : HomePage())
        //     : OnBoarding(),

        // Todo update the path to home page back
        // home: OnBoarding(),
        home: HomePage(),

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
