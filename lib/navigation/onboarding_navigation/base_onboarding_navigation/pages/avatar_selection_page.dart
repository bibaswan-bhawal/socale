import 'package:flutter/material.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/onboarding_page_interface.dart';
import 'package:socale/screens/onboarding/base_onboarding/avatar_selection/avatar_selection_screen.dart';
import 'package:socale/transitions/slide_horizontal_transition.dart';

class AvatarSelectionPage extends BaseOnboardingPage {
  const AvatarSelectionPage({super.key = const ValueKey('avatar_selection_page')});

  @override
  get child => const AvatarSelectionScreen();

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
