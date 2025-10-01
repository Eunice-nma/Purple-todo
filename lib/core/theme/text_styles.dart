import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sample_app/core/theme/app_colors.dart';

class AppTextStyles {
  // Display
  static TextStyle display32w7 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.black31,
  );
  // Headings
  static TextStyle heading24w7 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.black31,
  );
  static TextStyle heading20w6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.black31,
  );
  static TextStyle subHeading16w7 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.black31,
  );
  // Body
  static const TextStyle body14w5 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black31,
  );
  static const TextStyle body14w4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black36,
  );
  static const TextStyle body13w6 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.black31,
  );
  static TextStyle body13w7 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.black31,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  // Smaller text
  static TextStyle lable12w7 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.black31,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );
  static const TextStyle lable12w5 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.black31,
  );
}
