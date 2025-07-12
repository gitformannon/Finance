import 'package:flutter/material.dart';

import '../constants/app_colors.dart';


ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  fontFamily: 'fontRegular',

  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.primary),
    trackColor: MaterialStateProperty.all(AppColors.secondary),
    radius: const Radius.circular(8.0),
    thickness: MaterialStateProperty.all(6.0),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor:  AppColors.background,
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor:  Color(0xFF121212), // <- fon rangi
  primaryColor: AppColors.primary,
  fontFamily: 'fontRegular',

  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.8)),
    trackColor: MaterialStateProperty.all(AppColors.secondary.withOpacity(0.2)),
    radius: const Radius.circular(8.0),
    thickness: MaterialStateProperty.all(6.0),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor:  AppColors.background, // masalan: Color(0xFF121212)
    elevation: 0.0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    labelLarge: TextStyle(color: Colors.white),
  ),
);
