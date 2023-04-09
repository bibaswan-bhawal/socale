import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/model_providers.dart';
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
    final onboardingUser = ref.watch(onboardingUserProvider);

    Map<String, dynamic> data = onboardingUser.toJson();

    for (var key in data.keys) {
      print('$key: ${data[key]}');
    }

    return const ScreenScaffold(
      body: Center(
        child: Text('Welcome To Socale'),
      ),
    );
  }
}
