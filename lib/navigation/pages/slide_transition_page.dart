import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:socale/transitions/child_slide_transition.dart';

class SlideTransitionPage extends Page {
  final Widget child;
  final SharedAxisTransitionType transitionType;

  const SlideTransitionPage({super.key, required this.child, required this.transitionType});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ChildSlideTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
