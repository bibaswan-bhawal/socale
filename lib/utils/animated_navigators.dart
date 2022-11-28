import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimatedNavigators {
  static void goToWithSlide(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).push(
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

  static void replaceGoToWithSlide(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => screen),
    );
  }
}
