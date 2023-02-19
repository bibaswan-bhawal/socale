import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/curves.dart';

class FadeThroughAnimation extends StatelessWidget {
  final Animation<double> animation;

  final Widget first;
  final Widget second;

  const FadeThroughAnimation({
    super.key,
    required this.animation,
    required this.first,
    required this.second,
  });

  Animatable<double> get firstVisAnimation => Tween<double>(begin: 1, end: 0)
      .chain(CurveTween(curve: emphasizedAccelerate))
      .chain(CurveTween(curve: const Interval(0, 0.3)));

  Animatable<double> get secondVisAnimation => Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: emphasizedDecelerate))
      .chain(CurveTween(curve: const Interval(0.3, 1)));

  @override
  Widget build(BuildContext context) {
    return animation.value <= 0.3
        ? Opacity(
            opacity: firstVisAnimation.evaluate(animation),
            child: first,
          )
        : Opacity(
            opacity: secondVisAnimation.evaluate(animation),
            child: second,
          );
  }
}
