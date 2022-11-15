import 'package:flutter/material.dart';

class ColorValues {
  // App colors
  static const Color socaleDarkOrange = Color(0xFFFD6C00);
  static const Color socaleOrange = Color(0xFFFFA133);

  // Light Background circle Colors
  static const Color darkPurple = Color(0xFF7E3ECF);
  static const Color lightPurple = Color(0xFFF151DD);

  static const Color lightBlue = Color(0xFF36D1DC);
  static const Color darkBlue = Color(0xFF479CFF);

  // Social Sign in colors
  static const Color googleColor = Color(0xFFFFFFFF);
  static const Color facebookColor = Color(0xFF1877F2);
  static const Color appleColor = Color(0xFF000000);

  static const LinearGradient socaleGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [socaleOrange, socaleDarkOrange],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [lightPurple, darkPurple],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [lightBlue, darkBlue],
  );

  static const RadialGradient shadowGradient = RadialGradient(
    radius: 400,
    colors: [Colors.grey, Colors.transparent],
  );
}
