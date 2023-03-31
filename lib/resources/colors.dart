import 'dart:math';

import 'package:flutter/material.dart';

class ColorValues {
  // App colors
  static const Color primaryOrange = Color(0xFFFD6C00);
  static const Color secondaryOrange = Color(0xFFFFA133);

  static const Color primaryPurple = Color(0xFF7E3ECF);
  static const Color secondaryPurple = Color(0xFFF151DD);

  static const Color primaryBlue = Color(0xFF0C42FF);
  static const Color secondaryBlue = Color(0xFF7190FF);

  static const Color primaryLightBlue = Color(0xFF1A56C0);
  static const Color secondaryLightBlue = Color(0xFF39EDFF);

  static const Color textSubtitle = Color(0xFF7A7A7A);
  static const Color textLightSubtitle = Color(0xFFA7A7A7);

  static const Color textHint = Color(0xFF808080);

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryOrange, secondaryOrange],
    transform: GradientRotation((pi / 180) * -45),
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryPurple, secondaryPurple],
    transform: GradientRotation((pi / 180) * -45),
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryBlue, secondaryBlue],
    transform: GradientRotation((pi / 180) * -45),
  );

  static const LinearGradient lightBlueGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLightBlue, secondaryLightBlue],
    transform: GradientRotation((pi / 180) * -45),
  );

  static const LinearGradient transparentGradient = LinearGradient(
    colors: [Colors.transparent, Colors.transparent],
  );

  static const LinearGradient orangeTextGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.3, 0.7],
    colors: [primaryOrange, secondaryOrange],
    transform: GradientRotation((pi / 180) * -72),
  );

  static const LinearGradient lightBlueTextGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLightBlue, secondaryLightBlue],
    transform: GradientRotation((pi / 180) * -72),
  );

  static const LinearGradient orangeButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryOrange, secondaryOrange],
    stops: [0.32, 0.65],
    transform: GradientRotation((pi / 180) * -80),
  );

  static const LinearGradient blueButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primaryBlue, secondaryBlue],
    stops: [0.32, 0.65],
    transform: GradientRotation((pi / 180) * -80),
  );

  static const LinearGradient purpleButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primaryPurple, secondaryPurple],
    stops: [0.32, 0.65],
    transform: GradientRotation((pi / 180) * -80),
  );

  static const LinearGradient lightBlueButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primaryLightBlue, secondaryLightBlue],
    stops: [0.32, 0.65],
    transform: GradientRotation((pi / 180) * -80),
  );

  static const LinearGradient blackButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF202020), Color(0xFF4B4B4B)],
    stops: [0.32, 0.65],
    transform: GradientRotation((pi / 180) * -80),
  );

  static final Gradient cardGradientBackground = (const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x0DA18FEC),
      Color(0x0D80A9F9),
      Color(0x0DFF83F3),
      Color(0x0DE5CFA4),
      Color(0x0DEB7960),
    ],
  ).lerpTo(const LinearGradient(colors: [Colors.white, Colors.white]), 0.98))!;

  static const LinearGradient orangeBackgroundGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primaryOrange, secondaryOrange],
    transform: GradientRotation((pi / 180) * 30),
  );

  static const RadialGradient shadowGradient = RadialGradient(
    radius: 400,
    colors: [Colors.grey, Colors.transparent],
  );
}
