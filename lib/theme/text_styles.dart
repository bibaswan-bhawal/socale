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
  static TextStyle supportingText = GoogleFonts.roboto(
    color: SocaleColors.supportingTextColor,
  );
  static TextStyle textFieldHintText =
      supportingText.copyWith(color: supportingText.color!.withOpacity(0.5));
  static TextStyle appBarHeading = GoogleFonts.roboto(
    color: SocaleColors.highlightColor,
    fontSize: sText * 4,
    fontWeight: FontWeight.w700,
  );
  static TextStyle chatHeading = GoogleFonts.inter(
    color: SocaleColors.chatHeadingTextColor,
    fontSize: sText * 4,
    fontWeight: FontWeight.w500,
  );
}
