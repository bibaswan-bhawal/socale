import 'package:flutter/material.dart';

class SocaleColors {
  static Color mainShadowColor = Colors.black.withOpacity(0.5);
  static Color primaryHeadingColor = Colors.white;
  static Color supportingTextColor = Color(0xff8F9BB3);
  static Color bottomNavigationBarColor = Color(0xff1F2124);
  static Color highlightColor = Color(0xffFD6C00);
  static Color unHighighlitedBottomBarItemColor = Color(0xff8F9BB3);
  static Color searchBarColor = Color(0xFF2F3136);
  static Color homeBackgroundColor = Color(0xFF292B2F);
  static Color chatHeadingTextColor = Color(0xFFEEEEEE);
  static Color selectionColor = Color(0xFFFF7C03);
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
