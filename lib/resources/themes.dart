import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class Themes {
  static final ThemeData materialAppThemeData = ThemeData(
    canvasColor: Colors.transparent,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
      },
    ),
  );
}
