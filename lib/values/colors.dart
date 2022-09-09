import 'package:flutter/material.dart';

class ColorValues {
  static const Color textDescription = Color(0xE1383838);
  static const Color textHeading = Color(0xFF252525);
  static const Color textHeadingShadow = Color(0x19252525);
  static const Color textFieldError = Color(0xFFca1a3e);
  static Color textHint = Color(0x88383838);
  static Color formTextFieldBackgroundColor = const Color(0xFFFFFFFF).withOpacity(0.9);
  static const Color elementColor = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textOnLight = Color(0xFF000000);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color googleColor = Color(0xFFFFFFFF);
  static const Color facebookColor = Color(0xFF1877F2);
  static const Color appleColor = Color(0xFF000000);
  static const Color socaleDarkOrange = Color(0xFFFD6C00);
  static const Color socaleOrange = Color(0xFFFFA133);

  static final Shader socaleOrangeGradient = LinearGradient(
    colors: <Color>[Color(0xFFFD6C00), Color(0xFFFFA133)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
