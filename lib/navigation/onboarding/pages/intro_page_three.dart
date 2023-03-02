import 'package:flutter/material.dart';
import 'package:socale/navigation/transitions/slide_horizontal_transition.dart';
import 'package:socale/screens/onboarding/onboarding_intro_screen.dart';
import 'package:socale/screens/onboarding/onboarding_strings.dart';

class IntroPageThree extends Page {
  final Widget child = const OnboardingIntroScreen(
    illustration: 'assets/illustrations/onboarding_intro/cover_page_3.png',
    titleBlack: OnboardingStrings.introPage3TitleBlack,
    titleOrange: OnboardingStrings.introPage3TitleOrange,
    message: OnboardingStrings.introPage3Message,
  );

  const IntroPageThree({super.key = const ValueKey('intro_page_three')});

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
