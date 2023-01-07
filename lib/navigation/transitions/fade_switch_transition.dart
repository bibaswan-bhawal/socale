import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/curves.dart';

class FadeSwitchTransition extends StatelessWidget {
  final Animation<double> animation;
  final bool secondary;
  final double fadeMidpoint;
  final double scaleAmount;
  final Widget? child;

  const FadeSwitchTransition({
    super.key,
    required this.animation,
    this.secondary = false,
    this.fadeMidpoint = 0.5,
    this.scaleAmount = 0.92,
    this.child,
  });

  Animatable<double> get _fadeOutTransition => FlippedCurveTween(
        curve: emphasizedAccelerate,
      ).chain(CurveTween(curve: Interval(0.0, fadeMidpoint)));

  Animatable<double> get _fadeInTransition => CurveTween(
        curve: emphasizedDecelerate,
      ).chain(CurveTween(curve: Interval(fadeMidpoint, 1)));

  Animatable<double> get _scaleInTransition => Tween<double>(
        begin: secondary ? 1 : 0.92,
        end: 1,
      ).chain(CurveTween(curve: emphasized));

  Animatable<double> get _scaleOutTransition => Tween<double>(
        begin: 1,
        end: secondary ? 1 : 0.92,
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
              return Transform.scale(
                scale: _scaleInTransition.evaluate(animation),
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
              return Transform.scale(
                scale: _scaleOutTransition.evaluate(animation),
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
