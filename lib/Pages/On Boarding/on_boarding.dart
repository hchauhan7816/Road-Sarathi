import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/shared_preference.dart';
import 'package:sadak/Pages/Login%20Pages/login.dart';
import 'package:sadak/Pages/Login%20Pages/login_gov.dart';
import 'package:sadak/Pages/Signup%20Page/signup.dart';
import 'package:sadak/Pages/Slider/Widgets/constants.dart';
import 'package:sadak/Pages/Slider/splash_screen.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: SvgPicture.asset(
                "assets/icons/splash_bg.svg",
                //height: double.infinity,
              )),
          Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => LoginPage());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF6CD8D1),
                      minimumSize: Size(double.infinity, 65.0),
                      shape: StadiumBorder(),
                    ),
                    child: Text("Log In"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => LoginGovPage());
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF6CD8D1),
                      minimumSize: Size(double.infinity, 65.0),
                      shape: StadiumBorder(),
                    ),
                    child: Text("Log In Government"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => SignupPage());
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF6CD8D1),
                        minimumSize: Size(double.infinity, 65.0),
                        shape: StadiumBorder()),
                    child: Text("Sign Up"),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
