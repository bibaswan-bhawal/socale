import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class AppTextStyle {
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 24,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w600,
    color: AppColors.headline,
  );

  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 14,
    letterSpacing: -0.3,
    color: AppColors.subtitle,
  );
}
