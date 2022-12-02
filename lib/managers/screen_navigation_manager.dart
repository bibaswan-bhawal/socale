import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ScreenNavigationManager {
  late NavigatorState navigatorState;

  ScreenNavigationManager(BuildContext? context) {
    if (context == null) {
      throw ("Screen Navigator Context is null");
    }

    navigatorState = Navigator.of(context);
  }

  void goToWithSlide(Widget screen) {
    navigatorState.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  void replaceGoToWithSlide(Widget screen) {
    navigatorState.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }
}
