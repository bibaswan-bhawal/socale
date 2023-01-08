import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/slide_horizontal_transition.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';

class VerifyPage extends Page {
  final Widget child = const VerifyEmailScreen();

  const VerifyPage({super.key = const ValueKey('register_page')});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _Transition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}

class _Transition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _Transition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SlideHorizontalTransition(
      animation: animation,
      child: child,
    );
  }
}