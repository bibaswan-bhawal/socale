import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/base_onboarding_pages.dart';
import 'package:socale/screens/onboarding/assets/onboarding_strings.dart';
import 'package:socale/screens/onboarding/base_onboarding/introduction/onboarding_intro_screen.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class IntroPageOne extends BaseOnboardingPage {
  const IntroPageOne({super.key = const ValueKey('intro_page_one')});

  @override
  get child => const OnboardingIntroScreen(
        illustration: 'assets/illustrations/illustration_5.png',
        titleBlack: OnboardingStrings.introPage1TitleBlack,
        titleOrange: OnboardingStrings.introPage1TitleOrange,
        message: OnboardingStrings.introPage1Message,
      );

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
