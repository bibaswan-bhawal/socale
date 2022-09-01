import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/values/colors.dart';

class StyleValues {
  static final TextStyle heading1Style = GoogleFonts.poppins(
    fontSize: 32,
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

  static final TextStyle description1Style = GoogleFonts.roboto(
    fontSize: 14,
    textStyle: TextStyle(
      color: ColorValues.textDescription,
      letterSpacing: 0.25,
      height: 1.3,
    ),
  );

  static final TextStyle description2Style = GoogleFonts.roboto(
    fontSize: 18,
    textStyle: TextStyle(
      color: ColorValues.textDescription,
      letterSpacing: -1,
      height: 1.2,
    ),
  );

  static final TextStyle heading2Style = GoogleFonts.poppins(
    fontSize: 25,
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
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle outlinedButtonTextStyle = GoogleFonts.poppins(
    fontSize: 24,
    color: ColorValues.elementColor,
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

  static final OutlineInputBorder formTextFieldOutlinedBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: ColorValues.elementColor,
      width: 3,
    ),
  );

  static final OutlineInputBorder formTextFieldOutlinedBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: ColorValues.textFieldError,
      width: 2,
    ),
  );

  static final OutlineInputBorder formTextFieldOutlinedBorderErrorEnabled = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: ColorValues.textFieldError,
      width: 3,
    ),
  );

  static final OutlineInputBorder formTextFieldOutlinedBorderEnabled = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: ColorValues.elementColor,
      width: 2,
    ),
  );

  static final OutlineInputBorder chipFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  );

  static final BoxConstraints formTextFieldPrefixIconBoxConstraints = BoxConstraints(
    minHeight: 18,
    minWidth: 48,
  );

  static final PinTheme optPinTheme = PinTheme(
    shape: PinCodeFieldShape.underline,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 40,
    fieldWidth: 40,
    activeColor: Colors.black,
    selectedColor: ColorValues.socaleDarkOrange,
    inactiveColor: Colors.black,
  );
}
