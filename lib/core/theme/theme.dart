import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';

class ApplicationTheme {
  static ThemeData getAppThemeData() => ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: aquaGreenColor,
    primarySwatch: primarySwatchColor,
    scaffoldBackgroundColor: whiteColor,
    iconTheme: const IconThemeData(color: iconColor),
    // appBarTheme: const AppBarTheme(backgroundColor: backgroundBalticSeaColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryTextColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        fontSize: 23.sp,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 21.sp,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: bodyTextColor,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
      labelSmall: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
