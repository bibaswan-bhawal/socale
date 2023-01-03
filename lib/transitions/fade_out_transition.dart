import 'package:flutter/material.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/transitions/curves.dart';

class FadeOutTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const FadeOutTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  bool get exiting => secondaryAnimation.status == AnimationStatus.forward;
  bool get entering => secondaryAnimation.status == AnimationStatus.reverse;

  bool get secondary => exiting || entering;

  @override
  Widget build(BuildContext context) {
    Animatable<Offset> slideSecondaryTransition = Tween<Offset>(begin: Offset.zero, end: const Offset(-200, 0.0))
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate));

    Animatable<double> fadeSecondaryTransition = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: entering ? emphasizedDecelerate.flipped : emphasizedAccelerate))
        .chain(CurveTween(curve: const Interval(0, 0.5)));

    return Stack(
      children: [
        const LightOnboardingBackground(),
        FadeTransition(
          opacity: fadeSecondaryTransition.animate(secondaryAnimation),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: slideSecondaryTransition.evaluate(secondaryAnimation),
                child: child,
              );
            },
            child: child,
          ),
        ),
      ],
    );
  }
}
