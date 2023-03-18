import 'package:flutter/material.dart';
import 'package:socale/screens/intro/intro_screens.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class IntroPage {
  static Page first() => _IntroPage(key: const ValueKey('intro_page_first'), child: IntroScreen.first());

  static Page second() => _IntroPage(key: const ValueKey('intro_page_second'), child: IntroScreen.second());

  static Page third() => _IntroPage(key: const ValueKey('intro_page_third'), child: IntroScreen.third());
}

class _IntroPage extends Page {
  final Widget child;

  const _IntroPage({required this.child, required super.key});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideHorizontalTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
