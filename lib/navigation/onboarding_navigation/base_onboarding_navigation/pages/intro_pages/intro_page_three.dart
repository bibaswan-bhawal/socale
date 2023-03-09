import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/onboarding_page_interface.dart';
import 'package:socale/screens/onboarding/assets/onboarding_strings.dart';
import 'package:socale/screens/onboarding/base_onboarding/introduction/onboarding_intro_screen.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class IntroPageThree extends BaseOnboardingPage {
  const IntroPageThree({super.key = const ValueKey('intro_page_three')});

  @override
  get child => const OnboardingIntroScreen(
        illustration: 'assets/illustrations/illustration_3.png',
        titleBlack: OnboardingStrings.introPage3TitleBlack,
        titleOrange: OnboardingStrings.introPage3TitleOrange,
        message: OnboardingStrings.introPage3Message,
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
