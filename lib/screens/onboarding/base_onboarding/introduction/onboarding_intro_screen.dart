import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class OnboardingIntroScreen extends BaseOnboardingScreen {
  final String illustration;
  final String titleBlack;
  final String titleOrange;
  final String message;

  const OnboardingIntroScreen({
    super.key,
    required this.illustration,
    required this.titleBlack,
    required this.titleOrange,
    required this.message,
  });

  @override
  BaseOnboardingScreenState createState() => OnboardingIntroScreenState();
}

class OnboardingIntroScreenState extends BaseOnboardingScreenState {
  @override
  Future<bool> onNext() async => true;

  @override
  Future<bool> onBack() async => true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Center(
            child: Image.asset((widget as OnboardingIntroScreen).illustration),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (widget as OnboardingIntroScreen).titleBlack,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                      ).createShader(bounds),
                      child: Text(
                        (widget as OnboardingIntroScreen).titleOrange,
                        style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Text(
                  (widget as OnboardingIntroScreen).message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.036),
                    color: ColorValues.textSubtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
