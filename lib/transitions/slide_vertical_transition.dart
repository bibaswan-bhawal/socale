import 'package:flutter/material.dart';
import 'package:socale/transitions/curves.dart';

class SlideVerticalTransition extends StatelessWidget {
  final Animation<double> animation;
  final bool secondary;
  final double fadeMidpoint;
  final double slideAmount;
  final Widget? child;

  const SlideVerticalTransition({
    super.key,
    required this.animation,
    this.secondary = false,
    this.slideAmount = 30,
    this.fadeMidpoint = 0.3,
    this.child,
  });

  Animatable<double> get _fadeOutTransition => FlippedCurveTween(
        curve: emphasizedAccelerate,
      ).chain(CurveTween(curve: Interval(0.0, fadeMidpoint)));

  Animatable<double> get _fadeInTransition => CurveTween(
        curve: emphasizedDecelerate,
      ).chain(CurveTween(curve: Interval(fadeMidpoint, 1.0)));

  Animatable<Offset> get _slideInTransition => Tween<Offset>(
        begin: Offset(0.0, secondary ? -slideAmount : slideAmount),
        end: Offset.zero,
      ).chain(CurveTween(curve: emphasized));

  Animatable<Offset> get _slideOutTransition => Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, secondary ? -slideAmount : slideAmount),
      ).chain(CurveTween(curve: emphasized));

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: secondary ? ReverseAnimation(animation) : animation,
      child: child,
      forwardBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: _fadeInTransition.animate(animation),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideInTransition.evaluate(animation),
                child: child,
              );
            },
            child: child,
          ),
        );
      },
      reverseBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: _fadeOutTransition.animate(animation),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideOutTransition.evaluate(animation),
                child: child,
              );
            },
            child: child,
          ),
        );
      },
    );
  }
}
