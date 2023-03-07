import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_router.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_screen.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingRouter extends ConsumerStatefulWidget {
  const OnboardingRouter({super.key});

  @override
  ConsumerState<OnboardingRouter> createState() => _OnboardingRouterState();
}

class _OnboardingRouterState extends ConsumerState<OnboardingRouter> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
    checkCollegeEmailExists();
  }

  void checkCollegeEmailExists() => isEmailVerified = ref.read(onboardingUserProvider).collegeEmail != null;

  onboardingUserStateListener(OnboardingUser? oldState, OnboardingUser newState) {
    if (newState.collegeEmail != oldState?.collegeEmail) {
      checkCollegeEmailExists();
      setState(() {});
    }
  }

  Widget buildTransition(Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingUserProvider, onboardingUserStateListener);

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: buildTransition,
      child: isEmailVerified ? const BaseOnboardingRouter() : const VerifyCollegeScreen(),
    );
  }
}
