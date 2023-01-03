import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:socale/transitions/curves.dart';

class FadeOutTransition extends StatefulWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const FadeOutTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  State createState() => _FadeOutTransitionState();
}

class _FadeOutTransitionState extends State<FadeOutTransition> {
  bool onTop = true;

  @override
  void initState() {
    super.initState();

    widget.animation.addListener(handleAnimationChange);
    widget.secondaryAnimation.addListener(handleSecondaryAnimationChange);
  }

  @override
  void didUpdateWidget(FadeOutTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.animation.removeListener(handleAnimationChange);
    widget.animation.addListener(handleAnimationChange);

    oldWidget.secondaryAnimation.removeListener(handleSecondaryAnimationChange);
    widget.secondaryAnimation.addListener(handleSecondaryAnimationChange);
  }

  @override
  void dispose() {
    widget.animation.removeListener(handleAnimationChange);
    widget.secondaryAnimation.removeListener(handleSecondaryAnimationChange);

    super.dispose();
  }

  void handleAnimationChange() {
    setState(() => onTop = true);
  }

  void handleSecondaryAnimationChange() {
    setState(() => onTop = false);
  }

  bool get reversed => widget.secondaryAnimation.status == AnimationStatus.reverse;

  Widget onTopBuilder() {
    return widget.child;
  }

  Widget onBottomBuilder() {
    Animatable<double> fadeInTransition = CurveTween(
      curve: reversed ? emphasizedDecelerate : emphasizedAccelerate,
    ).chain(CurveTween(curve: const Interval(0.3, 1.0)));

    return FadeTransition(
      opacity: fadeInTransition.animate(ReverseAnimation(widget.secondaryAnimation)),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return onTop ? onTopBuilder() : onBottomBuilder();
  }
}
