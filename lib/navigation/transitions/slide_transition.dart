import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/curves.dart';

class SlideHorizontalTransition extends StatelessWidget {
  final Animation<double> animation;
  final bool secondary;
  final double fadeMidpoint;
  final double slideAmount;
  final Widget? child;

  const SlideHorizontalTransition({
    super.key,
    required this.animation,
    this.secondary = false,
    this.slideAmount = 30,
    this.fadeMidpoint = 0.5,
    this.child,
  });

  Animatable<double> get _fadeOutTransition => FlippedCurveTween(
        curve: emphasizedAccelerate,
      ).chain(CurveTween(curve: Interval(0.0, fadeMidpoint)));

  Animatable<Offset> get _slideOutTransition => Tween<Offset>(
        begin: Offset.zero,
        end: Offset(secondary ? -slideAmount : slideAmount, 0.0),
      ).chain(CurveTween(curve: emphasized));

  Animatable<double> get _fadeInTransition => CurveTween(
        curve: emphasizedDecelerate,
      ).chain(CurveTween(curve: Interval(fadeMidpoint, 1.0)));

  Animatable<Offset> get _slideInTransition => Tween<Offset>(
        begin: Offset(secondary ? -slideAmount : slideAmount, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: emphasized));

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
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
