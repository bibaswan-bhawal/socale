import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_action.dart';

class RegisterTransition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const RegisterTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  bool get pushing => animation.status == AnimationStatus.forward;
  bool get popping => animation.status == AnimationStatus.reverse;

  bool get primary => pushing || popping;

  bool get entering => secondaryAnimation.status == AnimationStatus.forward;
  bool get exiting => secondaryAnimation.status == AnimationStatus.reverse;

  bool get secondary => entering || exiting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedAxisTransition(
      fillColor: Colors.transparent,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      child: child,
    );
  }
}
