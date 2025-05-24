import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/constant/constant.dart';

class TypographyApp {
  static TextStyle headline1 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(10),
    fontWeight: FontWeight.w700,
    color: ColorApp.black,
  );

  static TextStyle headline2 = TextStyle(
    fontFamily: GoogleFonts.rubik().fontFamily,
    fontSize: ScreenUtil().setSp(8),
    fontWeight: FontWeight.w700,
    color: ColorApp.mainColor,
  );

  static TextStyle mdblack = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(8),
    fontWeight: FontWeight.w600,
    color: ColorApp.black,
  );

  static TextStyle text1 = TextStyle(
    fontFamily: GoogleFonts.rubik().fontFamily,
    fontSize: ScreenUtil().setSp(5),
    fontWeight: FontWeight.w400,
    color: ColorApp.mainColor,
  );

  static TextStyle text2 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(8),
    fontWeight: FontWeight.w400,
    color: ColorApp.black,
  );

  static TextStyle subText1 = TextStyle(
    fontFamily: GoogleFonts.rubik().fontFamily,
    fontSize: ScreenUtil().setSp(8),
    fontWeight: FontWeight.w300,
    color: ColorApp.lightGreen,
  );

  static TextStyle desc = TextStyle(
    fontFamily: GoogleFonts.rubik().fontFamily,
    fontSize: ScreenUtil().setSp(8),
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static TextStyle buttonText = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(5),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle titleField = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(5),
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}
