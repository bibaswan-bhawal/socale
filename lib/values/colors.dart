import 'package:flutter/material.dart';

class ColorValues {
  static const Color textDescription = Color(0xE1383838);
  static const Color textHeading = Color(0xFF252525);
  static const Color textHeadingShadow = Color(0x19252525);
  static const Color textFieldError = Color(0xFFca1a3e);
  static Color textHint = Color(0x88383838);
  static Color formTextFieldBackgroundColor =
      const Color(0xFFFFFFFF).withOpacity(0.9);
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

  static final Shader socaleTextGradient = LinearGradient(
    colors: <Color>[Color(0xFFFF87AB), Color(0xFFFFAC30)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 2.0, 1.0));

  static final Shader socaleLightPurpleGradient = LinearGradient(
    colors: <Color>[Color(0xFFF151DD), Color(0xFFDD9CFC)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static final LinearGradient shimmerGradientDark = LinearGradient(
    colors: [
      Color(0x8AD0D0D0),
      Color(0xAAF4F4F4),
      Color(0x8AD0D0D0),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static final LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xAAEBEBF4),
      Color(0x8AF4F4F4),
      Color(0xAAEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
