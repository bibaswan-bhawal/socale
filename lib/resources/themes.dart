import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'colors.dart';

class Themes {
  static final ThemeData materialAppThemeData = ThemeData(
    canvasColor: Colors.white,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
      },
    ),
  );

  static final PinTheme optPinTheme = PinTheme(
    shape: PinCodeFieldShape.underline,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 40,
    fieldWidth: 35,
    activeColor: Colors.black,
    selectedColor: ColorValues.socaleDarkOrange,
    inactiveColor: Colors.black,
  );
}
