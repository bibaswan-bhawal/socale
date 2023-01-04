import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/transitions/curves.dart';

class GetStartedTransition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const GetStartedTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DualTransitionBuilder(
      animation: ReverseAnimation(secondaryAnimation),
      forwardBuilder: (context, animation, child) {
        return _EnterSlideTransition(animation: animation, child: child);
      },
      reverseBuilder: (context, animation, child) {
        return _ExitSlideTransition(animation: animation, child: child);
      },
      child: child,
    );
  }
}

class _ExitSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget? child;

  const _ExitSlideTransition({required this.animation, this.child});

  static final Animatable<double> _fadeOutTransition = _FlippedCurveTween(
    curve: emphasizedAccelerate,
  ).chain(CurveTween(curve: const Interval(0.0, 0.4)));

  static final Animatable<Offset> _slideOutTransition = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-30.0, 0.0),
  ).chain(CurveTween(curve: emphasized));

  @override
  Widget build(BuildContext context) {
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
  }
}

class _EnterSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget? child;

  const _EnterSlideTransition({required this.animation, this.child});

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: emphasizedDecelerate,
  ).chain(CurveTween(curve: const Interval(0.4, 1.0)));

  static final Animatable<Offset> _slideInTransition = Tween<Offset>(
    begin: const Offset(-30.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: emphasized));

  @override
  Widget build(BuildContext context) {
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
  }
}

class _FlippedCurveTween extends CurveTween {
  /// Creates a vertically flipped [CurveTween].
  _FlippedCurveTween({
    required Curve curve,
  }) : super(curve: curve);

  @override
  double transform(double t) => 1.0 - super.transform(t);
}
