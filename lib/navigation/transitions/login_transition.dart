import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_action.dart';

class LoginTransition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const LoginTransition({
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
    return FadeTransition(
      opacity: getFadeTransition(ref),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: getSlideTransition(ref),
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Animation<double> getFadeTransition(ref) {
    // pushing
    Animatable<double> fadeInTransition = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: pushing ? emphasizedDecelerate : emphasizedAccelerate.flipped))
        .chain(CurveTween(curve: const Interval(0.5, 1.0)));

    // exiting
    Animatable<double> fadeOutTransition = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate))
        .chain(CurveTween(curve: const Interval(0.0, 0.6)));

    if (primary) {
      return fadeInTransition.animate(animation);
    } else {
      return fadeOutTransition.animate(secondaryAnimation);
    }
  }

  Offset getSlideTransition(ref) {
    bool pushingOnRegister = ref.read(authStateProvider).previousAuthAction == AuthAction.signUp;

    // pushing
    Animatable<Offset> slideInTransition = Tween<Offset>(begin: const Offset(300.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: pushing ? emphasizedDecelerate : emphasizedAccelerate.flipped))
        .chain(CurveTween(curve: const Interval(0.05, 1.0)));

    if (primary) {
      if (pushingOnRegister) {
        return Offset.zero;
      } else {
        return slideInTransition.evaluate(animation);
      }
    } else {
      return Offset.zero;
    }
  }
}
