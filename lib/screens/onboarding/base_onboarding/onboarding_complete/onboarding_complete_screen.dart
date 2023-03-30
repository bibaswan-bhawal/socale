import 'package:flutter/material.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class OnboardingCompleteScreen extends BaseOnboardingScreen {
  const OnboardingCompleteScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends BaseOnboardingScreenState {
  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome To Socale'),
      ],
    );
  }
}
