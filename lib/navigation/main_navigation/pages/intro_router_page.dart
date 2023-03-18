import 'package:flutter/material.dart';
import 'package:socale/screens/intro/intro_router.dart';
import 'package:socale/transitions/fade_switch_transition.dart';

class IntroRouterPage extends Page {
  const IntroRouterPage({super.key = const ValueKey('intro_router_page')});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const IntroRouter(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeSwitchTransition(
          animation: animation,
          child: FadeSwitchTransition(
            animation: secondaryAnimation,
            secondary: true,
            child: child,
          ),
        );
      },
    );
  }
}
