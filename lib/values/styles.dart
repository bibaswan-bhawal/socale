import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';

class StyleValues {
  static final TextStyle descriptionStyle = GoogleFonts.roboto(
    fontSize: 18,
    textStyle: TextStyle(
      color: ColorValues.textDescription,
      letterSpacing: -1,
      height: 1.2,
    ),
  );

  static final TextStyle headingStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    textStyle: TextStyle(
      color: ColorValues.textHeading,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(1, 2),
          blurRadius: 3,
          color: ColorValues.textHeadingShadow,
        ),
      ],
    ),
  );

  static final TextStyle primaryButtonTextStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle outlinedButtonTextStyle = GoogleFonts.poppins(
    fontSize: 24,
    color: const Color(0xFF000000),
    fontWeight: FontWeight.bold,
  );

  static final TextStyle textFieldHintStyle = GoogleFonts.poppins(
    fontSize: 14,
    textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      color: ColorValues.textHint,
    ),
  );
  static final TextStyle textFieldContentStyle = GoogleFonts.poppins(
    fontSize: 14,
    textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      color: ColorValues.textDescription,
    ),
  );

  static final OutlineInputBorder formTextFieldOutlinedBorderFocused =
      OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: const Color(0xFF000000),
      width: 3,
    ),
  );

  static final OutlineInputBorder formTextFieldOutlinedBorderEnabled =
      OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: const Color(0xFF000000),
      width: 2,
    ),
  );

  static final BoxConstraints formTextFieldPrefixIconBoxConstraints =
      BoxConstraints(
    minHeight: 18,
    minWidth: 48,
  );
}
