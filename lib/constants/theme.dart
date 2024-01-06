import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'app_color.dart';

ThemeData lighTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,

  scaffoldBackgroundColor: white,
  textTheme: const TextTheme(
    //display large
    
    displayLarge: TextStyle(
      color: gray900,
      fontSize: FontSizeManager.f34,
      fontWeight: FontWeightManager.bold,
      letterSpacing: 0.5,
    ),
    displaySmall: TextStyle(
      color: gray400,
      fontSize: FontSizeManager.f18,
      fontWeight: FontWeightManager.regular,
      letterSpacing: 0.5,
    ),

    labelMedium: TextStyle(
      fontSize: FontSizeManager.f18,
      fontWeight: FontWeightManager.semiBold,
    ),
    labelSmall: TextStyle(
      fontSize: FontSizeManager.f14,
      fontWeight: FontWeightManager.regular,
      color: gray600,
    ),

    labelLarge: TextStyle(
      fontSize: FontSizeManager.f16,
      fontWeight: FontWeightManager.regular,
      color: gray500,
    ),

    titleLarge: TextStyle(
      fontSize: FontSizeManager.f16,
      fontWeight: FontWeightManager.medium,
      color: gray900,
    ),

    titleMedium: TextStyle(
      fontSize: FontSizeManager.f12,
      color: gray900,
      fontWeight: FontWeightManager.medium,
    ),

    titleSmall: TextStyle(
      fontSize: FontSizeManager.f10,
      fontWeight: FontWeightManager.bold,
      letterSpacing: 0.5,
      color: red900,
    ),

    bodyLarge: TextStyle(
      fontSize: FontSizeManager.f16,
      fontWeight: FontWeightManager.regular,
      color: gray900,
    ),

    bodyMedium: TextStyle(
      fontSize: FontSizeManager.f14,
      fontWeight: FontWeightManager.regular,
      color: gray900,
    ),

    bodySmall: TextStyle(
      fontSize: FontSizeManager.f12,
      fontWeight: FontWeightManager.regular,
      color: gray900,
    ),

    headlineLarge: TextStyle(
      fontSize: FontSizeManager.f16,
      fontWeight: FontWeightManager.medium,
      color: gray900,
    ),

    headlineMedium: TextStyle(
      fontSize: FontSizeManager.f14,
      fontWeight: FontWeightManager.medium,
      color: gray900,
    ),

    headlineSmall: TextStyle(
      fontSize: FontSizeManager.f12,
      fontWeight: FontWeightManager.medium,
      color: gray900,
    ),

    


  ),
);
