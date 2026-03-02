import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/resources/color.dart';

final appTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.tempColor,
    surface: AppColors.bgMid,
  ),
  scaffoldBackgroundColor: AppColors.bgDark,
  useMaterial3: true,
  // Nunito: rounded, modern, highly readable — great for weather dashboards
  fontFamily: GoogleFonts.nunito().fontFamily,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.nunito(
        fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: AppColors.white),
    displayMedium: GoogleFonts.nunito(
        fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: AppColors.white),
    displaySmall: GoogleFonts.nunito(
        fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.white),
    headlineMedium: GoogleFonts.nunito(
        fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.25, color: AppColors.white),
    headlineSmall: GoogleFonts.nunito(
        fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.white),
    titleLarge: GoogleFonts.nunito(
        fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.15, color: AppColors.white),
    titleMedium: GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: AppColors.white),
    titleSmall: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.white),
    bodyLarge: GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: AppColors.white),
    bodyMedium: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: AppColors.white),
    labelLarge: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25, color: AppColors.white),
    bodySmall: GoogleFonts.nunito(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Color(0xAAFFFFFF)),
    labelSmall: GoogleFonts.nunito(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: Color(0xAAFFFFFF)),
  ),
);
