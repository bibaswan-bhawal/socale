import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/slide_vertical_transition.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_action.dart';

class ResetPasswordPage extends Page {
  final Widget child;

  const ResetPasswordPage({super.key, super.name = 'forgotPasswordPage', required this.child});

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
    return SlideVerticalTransition(
      animation: animation,
      child: child,
    );
  }
}
