import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding/pages/onboarding_page.dart';
import 'package:socale/navigation/transitions/slide_horizontal_transition.dart';
import 'package:socale/screens/onboarding/academic_info_major.dart';

class AcademicInfoMajorPage extends OnboardingPage {
  const AcademicInfoMajorPage({super.key = const ValueKey('academic_info_major_page')});

  @override
  get child => const AcademicInfoMajorScreen();

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
