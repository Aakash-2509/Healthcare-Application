import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'const_colors.dart';

TextTheme getTextTheme() {
  return TextTheme(
    headlineLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 80.sp,
    ),
    headlineMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 15.sp,
    ),
    headlineSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 10.sp,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 70.sp,
    ),
    bodyMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: ConstColors.black,
        fontSize: 70.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.black),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.darkGrey,
      fontSize: 18.sp,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 70.sp,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 12.sp,
    ),
    titleSmall: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      color: ConstColors.black,
      decoration: TextDecoration.none,
      fontSize: 10.sp,
    ),
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.backgroundColor,
      decoration: TextDecoration.none,
      fontSize: 13.sp,
    ),
    displayMedium: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        color: ConstColors.primaryColor,
        fontSize: 13.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.primaryColor),
    displaySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 13.sp,
      color: ConstColors.primaryColor,
      decoration: TextDecoration.none,
    ),
  );
}

//Light TextTheme
TextTheme getLightTextTheme() {
  return TextTheme(
    headlineLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      fontSize: 70.sp,
    ),
    headlineMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.black,
      fontSize: 12.sp,
    ),
    headlineSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.black,
      fontSize: 10.sp,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      fontSize: 70.sp,
    ),
    bodyMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: ConstColors.black,
        fontSize: 70.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.black),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.darkGrey,
      fontSize: 18.sp,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.darkGrey,
      fontSize: 70.sp,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.darkGrey,
      fontSize: 12.sp,
    ),
    titleSmall: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      color: ConstColors.darkGrey,
      fontSize: 10.sp,
    ),
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.backgroundColor,
      fontSize: 13.sp,
    ),
    displayMedium: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        color: ConstColors.primaryColor,
        fontSize: 13.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.primaryColor),
    displaySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 13.sp,
      color: ConstColors.primaryColor,
    ),
  );
}

//Dark TextTheme
TextTheme getDarkTextTheme() {
  return TextTheme(
    headlineLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.lightGrey,
      fontSize: 70.sp,
    ),
    headlineMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.lightGrey,
      fontSize: 12.sp,
    ),
    headlineSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: ConstColors.lightGrey,
      fontSize: 10.sp,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.lightGrey,
      fontSize: 70.sp,
    ),
    bodyMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: ConstColors.lightGrey,
        fontSize: 70.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.lightGrey),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.lightGrey,
      fontSize: 18.sp,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.lightGrey,
      fontSize: 70.sp,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.lightGrey,
      fontSize: 12.sp,
    ),
    titleSmall: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      color: ConstColors.lightGrey,
      fontSize: 10.sp,
    ),
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: ConstColors.black,
      fontSize: 13.sp,
    ),
    displayMedium: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        color: ConstColors.primaryColor,
        fontSize: 13.sp,
        decoration: TextDecoration.underline,
        decorationColor: ConstColors.primaryColor),
    displaySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 13.sp,
      color: ConstColors.primaryColor,
    ),
  );
}
