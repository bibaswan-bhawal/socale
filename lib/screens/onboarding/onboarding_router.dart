import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_router.dart';
import 'package:socale/screens/onboarding/onboarding_complete/onboarding_complete_screen.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_screen.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingRouter extends ConsumerStatefulWidget {
  const OnboardingRouter({super.key});

  @override
  ConsumerState<OnboardingRouter> createState() => _OnboardingRouterState();
}

class _OnboardingRouterState extends ConsumerState<OnboardingRouter> {
  Widget buildTransition(Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child);
  }

  Widget buildPage() {
    final onboardingUser = ref.read(onboardingUserProvider);

    if (onboardingUser.isCollegeEmailVerified) {
      ref.read(emailVerificationProvider).dispose();

      if (onboardingUser.isOnboardingComplete) return const OnboardingCompleteScreen();
      return const BaseOnboardingRouter();
    } else {
      return const VerifyCollegeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUIDark();

    ref.watch(onboardingUserProvider);

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: buildTransition,
      child: buildPage(),
    );
  }
}
