import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/register_transition.dart';

class RegisterPage extends Page {
  final Widget child;

  const RegisterPage({super.key, super.name = 'registerPage', required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RegisterTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
