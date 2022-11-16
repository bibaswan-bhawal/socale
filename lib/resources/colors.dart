import 'dart:math';

import 'package:flutter/material.dart';

class ColorValues {
  // App colors
  static const Color socaleDarkOrange = Color(0xFFFD6C00);
  static const Color socaleOrange = Color(0xFFFFA133);

  // Light Background circle Colors
  static const Color darkPurple = Color(0xFF7E3ECF);
  static const Color lightPurple = Color(0xFFF151DD);

  static const Color lightBlue = Color(0xFF7190FF);
  static const Color darkBlue = Color(0xFF0C42FF);

  static const LinearGradient orangeButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [socaleDarkOrange, socaleOrange],
    stops: [0.3, 0.7],
    transform: GradientRotation((pi / 180) * -72),
  );

  static const LinearGradient purpleButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [darkBlue, lightBlue],
    stops: [0.3, 0.7],
    transform: GradientRotation((pi / 180) * -72),
  );

  static final Gradient groupInputBackgroundGradient = (LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [
      const Color(0x0DA18FEC),
      const Color(0x0D80A9F9),
      const Color(0x0DFF83F3),
      const Color(0x0DE5CFA4),
      const Color(0x0DEB7960),
    ],
  ).lerpTo(LinearGradient(colors: [Colors.white, Colors.white]), 0.95))!;

  static const LinearGradient orangeBackgroundGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [socaleDarkOrange, socaleOrange],
    transform: GradientRotation((pi / 180) * 30),
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
