import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/theme/size_config.dart';

import 'colors.dart';

class SocaleTextStyles {
  static TextStyle loginScreenHeading = GoogleFonts.roboto(
    color: SocaleColors.primaryHeadingColor,
    fontSize: sText * 8,
    fontWeight: FontWeight.bold,
  );
  static TextStyle loginScreenSupportingText = GoogleFonts.roboto(
    color: SocaleColors.supportingTextColor,
  );
}
