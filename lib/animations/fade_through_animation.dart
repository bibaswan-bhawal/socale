import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/curves.dart';

class FadeThroughAnimation extends StatelessWidget {
  final Animation<double> animation;

  final Widget first;
  final Widget second;
  final double midPoint;

  const FadeThroughAnimation({
    super.key,
    required this.animation,
    required this.first,
    required this.second,
    this.midPoint = 0.3,
  });

  Animatable<double> get firstVisAnimation =>
      Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: emphasizedAccelerate)).chain(CurveTween(curve: Interval(0, midPoint)));

  Animatable<double> get secondVisAnimation =>
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: emphasizedDecelerate)).chain(CurveTween(curve: Interval(midPoint, 1)));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: firstVisAnimation.evaluate(animation),
          child: first,
        ),
        Opacity(
          opacity: secondVisAnimation.evaluate(animation),
          child: second,
        )
      ],
    );
  }
}
