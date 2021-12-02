import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle appTitleStyle = GoogleFonts.grandHotel(fontSize: 36);
final TextStyle universalTextFont = GoogleFonts.cairo(fontSize: 17);

TextStyle heading1() {
  return TextStyle(
    fontSize: 100.sp,
    fontWeight: FontWeight.w400,
  );
}

TextStyle normal1() {
  return TextStyle(
    fontSize: 55.sp,
    color: Colors.black87,
  );
}

TextStyle normal2() {
  return TextStyle(
    fontSize: 55.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
}

TextStyle normal3() {
  return TextStyle(
    fontSize: 50.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );
}

TextStyle small1() {
  return TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );
}
