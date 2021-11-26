import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Config/palette.dart';

class Themes {
  final lightTheme = ThemeData(
    // primarySwatch: Colors.,
    fontFamily: "Cairo",
    // primaryColor: Colors.white,
    // disabledColor: Colors.grey,
    // cardColor: Colors.white,
    // canvasColor: Colors.white,
    // fontFamily: Devfest.googleSansFamily,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Palette.peach,
      iconTheme: IconThemeData(color: Colors.black),
      // backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        //   fontSize: 55.sp,
        //   fontWeight: FontWeight.w500,
      ),
    ),
  );

  // final darkTheme = ThemeData.dark().copyWith(
  //   textTheme: ThemeData.dark().textTheme.apply(
  //       // fontFamily: Devfest.googleSansFamily,
  //       ),
  //   appBarTheme: AppBarTheme(
  //     backgroundColor: Colors.black,
  //     elevation: 0,
  //     titleTextStyle: TextStyle(
  //       color: Colors.white,
  //       fontSize: 55.sp,
  //       fontWeight: FontWeight.w500,
  //     ),
  //   ),
  //   primaryColor: Colors.red[800],
  //   scaffoldBackgroundColor: Colors.black,
  // );
}
