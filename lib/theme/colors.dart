import 'package:flutter/material.dart';

class SocaleColors {
  static Color mainShadowColor = Colors.black.withOpacity(0.5);
  static Color primaryHeadingColor = Colors.white;
  static Color supportingTextColor = Color(0xff8F9BB3);
}

class SocaleGradients {
  static LinearGradient mainBackgroundGradient = LinearGradient(
    colors: const [Color(0xd0ffa133), Color(0xffFD6C00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient loginScreenBottomSectionGradient = LinearGradient(
    colors: const [Color(0xff040404), Color(0xff444444)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
