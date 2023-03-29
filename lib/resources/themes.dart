import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'colors.dart';

class Themes {
  static final PinTheme optPinTheme = PinTheme(
    shape: PinCodeFieldShape.underline,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 40,
    fieldWidth: 35,
    activeColor: Colors.black,
    selectedColor: ColorValues.primaryOrange,
    inactiveColor: Colors.black,
  );
}
