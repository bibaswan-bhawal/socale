import 'package:flutter/material.dart';
import 'package:socale/transitions/curves.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';

class ChildSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const ChildSlideTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  bool get pushing => animation.status == AnimationStatus.forward;
  bool get popping => animation.status == AnimationStatus.reverse;

  bool get pushed => animation.status == AnimationStatus.completed;

  @override
  Widget build(BuildContext context) {
    // entering
    Animatable<Offset> slideInTransition = Tween<Offset>(begin: const Offset(300, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: pushing ? emphasizedDecelerate : emphasizedAccelerate.flipped));

    // entering
    Animatable<double> fadeInTransition = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: pushing ? emphasizedDecelerate : emphasizedAccelerate.flipped))
        .chain(CurveTween(curve: const Interval(0.5, 1)));

    return Stack(
      children: [
        if (pushed) const LightOnboardingBackground(),
        FadeTransition(
          opacity: fadeInTransition.animate(animation),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: slideInTransition.evaluate(animation),
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
