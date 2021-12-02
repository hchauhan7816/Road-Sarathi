import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sadak/Config/palette.dart';

class Themes {
  final lightTheme = ThemeData(
    fontFamily: "Cairo",
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Palette.peach,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
