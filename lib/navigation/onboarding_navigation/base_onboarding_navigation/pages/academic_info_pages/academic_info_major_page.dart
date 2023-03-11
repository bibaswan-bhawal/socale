import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/onboarding_page_interface.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_major.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class AcademicInfoMajorPage extends BaseOnboardingPage {
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