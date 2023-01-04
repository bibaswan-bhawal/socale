import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/get_started_transition.dart';

class GetStartedPage extends Page {
  final Widget child;

  const GetStartedPage({super.key, super.name = 'getStartedPage', required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return GetStartedTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
