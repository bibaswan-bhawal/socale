import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_action.dart';

class LoginTransition extends ConsumerWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const LoginTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  bool get pushing => animation.status == AnimationStatus.forward;
  bool get popping => animation.status == AnimationStatus.reverse;

  bool get primary => pushing || popping;

  bool get entering => secondaryAnimation.status == AnimationStatus.forward;
  bool get exiting => secondaryAnimation.status == AnimationStatus.reverse;

  bool get secondary => entering || exiting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) {
        return _PushSlideTransition(
          animation: animation,
          child: child,
        );
      },
      reverseBuilder: (context, animation, child) {
        return _PopSlideTransition(
          animation: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}

class _PopSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget? child;

  const _PopSlideTransition({required this.animation, this.child});

  static final Animatable<double> _fadeOutTransition = _FlippedCurveTween(
    curve: emphasizedAccelerate,
  ).chain(CurveTween(curve: const Interval(0.0, 0.4)));

  static final Animatable<Offset> _slideOutTransition = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(30.0, 0.0),
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

class _PushSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget? child;

  const _PushSlideTransition({required this.animation, this.child});

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: emphasizedDecelerate,
  ).chain(CurveTween(curve: const Interval(0.4, 1.0)));

  static final Animatable<Offset> _slideInTransition = Tween<Offset>(
    begin: const Offset(30.0, 0.0),
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
  _FlippedCurveTween({required super.curve});

  @override
  double transform(double t) => 1.0 - super.transform(t);
}
