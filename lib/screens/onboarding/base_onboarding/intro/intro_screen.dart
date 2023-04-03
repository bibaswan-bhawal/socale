import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class OnboardingIntroScreen extends BaseOnboardingScreen {
  const OnboardingIntroScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends BaseOnboardingScreenState {
  @override
  Future<bool> onNext() async {
    return true;
  }

  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    College college = ref.watch(onboardingUserProvider.select((value) => value.college!));

    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: GradientHeadline(
            headlinePlain: 'Welcome to',
            headlineColored: college.name,
            newLine: true,
          ),
        ),
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 44),
            child: SizedBox(
              width: size.width * 0.8,
              child: college.profileImage,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            'We are thrilled to have you be a part of the\n'
            '${college.communityName} community. Before you jump right in\n'
            'and explore Socale, create a profile to fully\n'
            'experience everything ${college.shortName} has to offer.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.subtitle,
            ),
          ),
        ),
        Text(
          college.funFact, // pick random fun fact
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppColors.lightSubtitle,
          ),
        ),
      ],
    );
  }
}
