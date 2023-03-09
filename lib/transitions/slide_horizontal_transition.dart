import 'package:flutter/material.dart';
import 'package:socale/transitions/curves.dart';

class SlideHorizontalTransition extends StatelessWidget {
  final Animation<double>? animation;
  final Animation<double>? secondaryAnimation;

  final double? fadeMidpoint;
  final double? slideAmount;

  final Widget? child;

  const SlideHorizontalTransition({
    super.key,
    this.animation,
    this.secondaryAnimation,
    this.child,
    this.fadeMidpoint,
    this.slideAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (animation == null) {
      return _SlideHorizontalTransitionBase(
        animation: secondaryAnimation!,
        secondary: true,
        fadeMidpoint: fadeMidpoint ?? 0.3,
        slideAmount: slideAmount ?? 30,
        child: child,
      );
    }
    if (secondaryAnimation == null) {
      return _SlideHorizontalTransitionBase(
        animation: animation!,
        fadeMidpoint: fadeMidpoint ?? 0.3,
        slideAmount: slideAmount ?? 30,
        child: child,
      );
    }

    return _SlideHorizontalTransitionBase(
      animation: animation!,
      fadeMidpoint: fadeMidpoint ?? 0.3,
      slideAmount: slideAmount ?? 30,
      child: _SlideHorizontalTransitionBase(
        animation: secondaryAnimation!,
        secondary: true,
        fadeMidpoint: fadeMidpoint ?? 0.3,
        slideAmount: slideAmount ?? 30,
        child: child,
      ),
    );
  }
}

class _SlideHorizontalTransitionBase extends StatelessWidget {
  final Animation<double> animation;
  final bool secondary;
  final double fadeMidpoint;
  final double slideAmount;
  final Widget? child;

  const _SlideHorizontalTransitionBase({
    required this.animation,
    this.secondary = false,
    required this.slideAmount,
    required this.fadeMidpoint,
    this.child,
  });

  Animatable<double> get _fadeOutTransition => FlippedCurveTween(
        curve: emphasizedAccelerate,
      ).chain(CurveTween(curve: Interval(0.0, fadeMidpoint)));

  Animatable<double> get _fadeInTransition => CurveTween(
        curve: emphasizedDecelerate,
      ).chain(CurveTween(curve: Interval(fadeMidpoint, 1.0)));

  Animatable<Offset> get _slideInTransition => Tween<Offset>(
        begin: Offset(secondary ? -slideAmount : slideAmount, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: emphasized));

  Animatable<Offset> get _slideOutTransition => Tween<Offset>(
        begin: Offset.zero,
        end: Offset(secondary ? -slideAmount : slideAmount, 0.0),
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
