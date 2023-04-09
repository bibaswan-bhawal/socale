import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
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
    return ScreenScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Welcome To Socale'),
          ElevatedButton(
              onPressed: () {
                final onboardingUser = ref.read(onboardingUserProvider);

                print(onboardingUser);

                final onboardingService = ref.read(onboardingServiceProvider);

                onboardingService.onboardUser();
              },
              child: const Text('Create User')),
        ],
      ),
    );
  }
}
