import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding/pages/onboarding_page.dart';
import 'package:socale/navigation/transitions/slide_horizontal_transition.dart';
import 'package:socale/screens/onboarding/basic_info/basic_info_screen.dart';

class BasicInfoPage extends OnboardingPage {
  const BasicInfoPage({super.key = const ValueKey('basic_info_page')});

  @override
  get child => const BasicInfoScreen();

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
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
