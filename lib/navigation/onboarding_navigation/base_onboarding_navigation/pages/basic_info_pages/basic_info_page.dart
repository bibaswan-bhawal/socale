import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/base_onboarding_pages.dart';
import 'package:socale/screens/onboarding/base_onboarding/basic_info/basic_info_screen.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class BasicInfoPage extends BaseOnboardingPage {
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
