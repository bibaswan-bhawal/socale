import 'package:flutter/material.dart';
import 'package:socale/transitions/curves.dart';

enum SlideDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

class ChildSlideTransition extends StatefulWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const ChildSlideTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  State<ChildSlideTransition> createState() => _ChildSlideTransitionState();
}

class _ChildSlideTransitionState extends State<ChildSlideTransition> {
  bool onTop = true;

  @override
  void initState() {
    super.initState();

    widget.animation.addListener(handleAnimationChange);
    widget.secondaryAnimation.addListener(handleSecondaryAnimationChange);
  }

  @override
  void didUpdateWidget(ChildSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.animation.removeListener(handleAnimationChange);
    widget.animation.addListener(handleAnimationChange);

    oldWidget.secondaryAnimation.removeListener(handleSecondaryAnimationChange);
    widget.secondaryAnimation.addListener(handleSecondaryAnimationChange);
  }

  @override
  void dispose() {
    super.dispose();

    widget.animation.removeListener(handleAnimationChange);
    widget.secondaryAnimation.removeListener(handleSecondaryAnimationChange);
  }

  void handleAnimationChange() {
    setState(() => onTop = true);
  }

  void handleSecondaryAnimationChange() {
    setState(() => onTop = false);
  }

  bool get reversed => widget.animation.status == AnimationStatus.reverse;

  Widget buildOnTopTransition() {
    final size = MediaQuery.of(context).size;

    Animatable<Offset> slideInTransition = Tween<Offset>(
      begin: const Offset(30, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: reversed ? emphasizedDecelerate : emphasizedAccelerate));

    Animatable<double> fadeInTransition = CurveTween(
      curve: reversed ? emphasizedDecelerate : emphasizedAccelerate,
    ).chain(CurveTween(curve: const Interval(0.3, 1.0)));

    return FadeTransition(
        opacity: fadeInTransition.animate(widget.animation),
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Transform.translate(
              offset: slideInTransition.evaluate(widget.animation),
              child: widget.child,
            );
          },
        ));
  }

  Widget buildOnBottomTransition() {
    final size = MediaQuery.of(context).size;

    final Animatable<Offset> slideUpTransition = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -size.height),
    ).chain(CurveTween(curve: emphasizedAccelerate));

    return Transform.translate(
      offset: slideUpTransition.evaluate(widget.secondaryAnimation),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return onTop ? buildOnTopTransition() : buildOnBottomTransition();
  }
}
