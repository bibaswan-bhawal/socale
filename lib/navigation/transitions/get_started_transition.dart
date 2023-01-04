import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/navigation/transitions/curves.dart';

class GetStartedTransition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const GetStartedTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  bool get exiting => secondaryAnimation.status == AnimationStatus.forward;
  bool get entering => secondaryAnimation.status == AnimationStatus.reverse;

  bool get pushing => animation.status == AnimationStatus.forward;
  bool get popping => animation.status == AnimationStatus.reverse;

  bool get secondary => exiting || entering;
  bool get primary => pushing || popping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Animatable<Offset> slideSecondaryTransition = Tween<Offset>(begin: Offset.zero, end: const Offset(-300, 0.0))
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate));

    Animatable<double> fadeOutTransition = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate))
        .chain(CurveTween(curve: const Interval(0, 0.5)));

    Animatable<double> fadeInTransition = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate))
        .chain(CurveTween(curve: const Interval(0.5, 1)));

    return FadeTransition(
      opacity: primary ? fadeInTransition.animate(animation) : fadeOutTransition.animate(secondaryAnimation),
      child: AnimatedBuilder(
        animation: secondaryAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: primary ? const Offset(0.0, 0.0) : slideSecondaryTransition.evaluate(secondaryAnimation),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
