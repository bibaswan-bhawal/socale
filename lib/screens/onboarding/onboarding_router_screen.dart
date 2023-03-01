import 'package:flutter/material.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/screens/onboarding/onboarding_intro_screen.dart';
import 'package:socale/screens/onboarding/onboarding_strings.dart';

class OnboardingRouterScreen extends StatelessWidget {
  const OnboardingRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          const Expanded(
            child: OnboardingIntroScreen(
              illustration: 'assets/illustrations/onboarding_intro/cover_page_1.png',
              titleBlack: OnboardingStrings.introPage1TitleBlack,
              titleOrange: OnboardingStrings.introPage2TitleOrange,
              message: OnboardingStrings.introPage1Message,
            ),
          ),
          PageViewController(
            currentPage: 0,
            pageCount: 6,
            back: () {},
            next: () {},
            nextText: 'Next',
            backText: 'Sign Out',
          ),
        ],
      ),
    );
  }
}
