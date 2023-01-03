import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class LoginPage extends Page {
  final Widget child;

  const LoginPage({super.key, required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }
}
