import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Config/text_styles.dart';

class LoginGovPage extends StatelessWidget {
  const LoginGovPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: LoginGovBody(), appBar: loginAppBar(context));
  }
}

AppBar loginAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    title: const Text("Government Login"),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      iconSize: 20,
      color: Colors.black,
    ),
  );
}

class LoginGovBody extends StatelessWidget {
  LoginGovBody({Key? key}) : super(key: key);

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  TextEditingController? email = TextEditingController();

  TextEditingController? password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        height: 1970.h,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Government Login",
                          style: heading1(),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          "Login to your account",
                          style: normal3(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextField(
                                controller: email,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.h, horizontal: 15.w),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              SizedBox(
                                height: 30.h,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.h, horizontal: 15.w),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              SizedBox(
                                height: 30.h,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),

                    // Login Button
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 150.h,
                      onPressed: () {
                        if (email != null &&
                            password != null &&
                            email!.text.isNotEmpty &&
                            password!.text.isNotEmpty) {
                          firebaseHelper.signInGovernment(
                              email: email!.text, password: password!.text);
                        } else {
                          Get.snackbar(
                              "Error", "Please Enter email and password");
                        }
                      },
                      color: Palette.darkPurple,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Palette.darkPurple),
                        borderRadius: BorderRadius.circular(75.w),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 55.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 60.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: small1(),
                        ),
                        // Todo Sign up linking
                        const Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    Container(
                      height: 700.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/login_gov.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
