import 'package:flutter/material.dart';
import 'package:socale/screens/auth/auth_router.dart';
import 'package:socale/transitions/fade_switch_transition.dart';

class AuthPage extends Page {
  final Widget child = const AuthRouter();

  const AuthPage({super.key = const ValueKey('auth_page')});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
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
    return FadeSwitchTransition(
      animation: animation,
      child: FadeSwitchTransition(
        animation: secondaryAnimation,
        secondary: true,
        child: child,
      ),
    );
  }
}
