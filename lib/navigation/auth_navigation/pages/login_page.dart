import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/transitions/fade_switch_transition.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';
import 'package:socale/transitions/slide_vertical_transition.dart';
import 'package:socale/types/auth/auth_step.dart';

class LoginPage extends Page {
  final Widget child = const LoginScreen();

  const LoginPage({super.key = const ValueKey('login_page')});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
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

class _Transition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _Transition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthStep? previousStep = ref.read(authStateProvider).previousStep;
    AuthStep step = ref.read(authStateProvider).step;

    if (step == AuthStep.register && previousStep == AuthStep.login) {
      return FadeSwitchTransition(
        animation: secondaryAnimation,
        secondary: true,
        child: child,
      );
    }

    if (step == AuthStep.login && previousStep == AuthStep.register) {
      return FadeSwitchTransition(
        animation: animation,
        child: child,
      );
    }

    if (step == AuthStep.forgotPassword && previousStep == AuthStep.login) {
      return SlideVerticalTransition(
        animation: secondaryAnimation,
        secondary: true,
        child: child,
      );
    }

    if (step == AuthStep.login && previousStep == AuthStep.forgotPassword) {
      return SlideVerticalTransition(
        animation: secondaryAnimation,
        secondary: true,
        child: child,
      );
    }

    return SlideHorizontalTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}