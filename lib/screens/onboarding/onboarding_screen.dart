import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/screens/onboarding/basic_info_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LightOnboardingBackground(),
          PageView(
            children: const [
              BasicInfoPage(),
            ],
          ),
        ],
      ),
    );
  }
}
