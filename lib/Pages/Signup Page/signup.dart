import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:sadak/Config/text_styles.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: SignupBody(), appBar: signupAppBar(context));
  }
}

AppBar signupAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    title: const Text("Sign Up"),
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

class SignupBody extends StatelessWidget {
  SignupBody({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController password2 = TextEditingController();

  signUpUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (password.text == password2.text) {
        firebaseHelper.signUp(
            name: name.text, email: email.text, password: password.text);
      } else {
        Get.snackbar("Error!", "Confirm Password does not match.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        height: 1970.h,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Sign up",
                  style: heading1(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Create an account",
                  style: normal3(),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name",
                            style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Name cannot be empty";
                              }

                              return null;
                            },
                            controller: name,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.h, horizontal: 15.w),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
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
                            "Email",
                            style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Email cannot be empty";
                              } else if (val.length < 4) {
                                return "Too short email";
                              }

                              return null;
                            },
                            controller: email,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.h, horizontal: 15.w),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
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
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Password cannot be empty";
                              } else if (val.length < 5) {
                                return "Password too short";
                              }

                              return null;
                            },
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.h, horizontal: 15.w),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
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
                            "Confirm Password",
                            style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Password cannot be empty";
                              } else if (val.length < 5) {
                                return "Password too short";
                              }

                              return null;
                            },
                            obscureText: true,
                            controller: password2,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.h, horizontal: 15.w),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
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
              ],
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 150.h,
              onPressed: () {
                signUpUser(context);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account?",
                  style: small1(),
                ),
                // Todo Sign up linking

                GestureDetector(
                  onTap: () {
                    Get.off(() => OnBoarding());
                  },
                  child: Text(
                    " Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
