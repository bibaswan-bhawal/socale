import 'package:flutter/material.dart';
import 'package:socale/transitions/fade_out_transition.dart';

class FadeOutPage extends Page {
  final Widget child;

  FadeOutPage({super.key, required this.child}) {
    print('build new fade page route');
  }

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeOutTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
