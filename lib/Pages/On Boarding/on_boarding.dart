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

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: OnBoardingBody(), appBar: null);
  }
}

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({Key? key}) : super(key: key);

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  navigateUser() async {
    setState(() {
      isLoading = true;
    });

    bool? haveEverUsedApp = await HelperFunctions.getUsedAppSharedPreference();

    if (haveEverUsedApp == null || haveEverUsedApp == false) {
      Get.offAll(SplashScreen());
    }

    HelperFunctions.saveUsedAppSharedPreference(true);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kActiveIconColor,
              ),
            )
          : Container(
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
              Get.to(() => LoginPage());
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
              Get.to(() => LoginGovPage());
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
              Get.to(() => SignupPage());
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
