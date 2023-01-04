import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends Page {
  final Widget child;

  const ResetPasswordPage({super.key, super.name = 'forgotPasswordPage', required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: child,
        );
      },
    );
  }
}
