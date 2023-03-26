import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AvatarSelectionScreen extends BaseOnboardingScreen {
  const AvatarSelectionScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends BaseOnboardingScreenState {
  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    return false;
  }

  Future<void> reRoll() async {
    final (String username, String profileImage) = await ref.read(onboardingServiceProvider).generateProfile();

    ref.read(onboardingUserProvider.notifier).setAnonymousUsername(username);
    ref.read(onboardingUserProvider.notifier).setAnonymousProfileImage(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingUser = ref.watch(onboardingUserProvider);

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.05),
          child: SimpleShadow(
            opacity: 0.1,
            offset: const Offset(1, 1),
            sigma: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Meet your new',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                      ).createShader(bounds),
                      child: Text(
                        'anonymous ',
                        style: GoogleFonts.poppins(
                            fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Text(
                      'avatar',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 45),
          child: SimpleShadow(
            opacity: 0.2,
            offset: const Offset(0, 4),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0,
                maxHeight: size.width * 0.6,
                minWidth: 0,
                maxWidth: size.width * 0.6,
              ),
              child: onboardingUser.anonymousProfileImage!,
            ),
          ),
        ),
        Text(
          onboardingUser.anonymousUsername ?? '',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GradientButton(
            text: 'Re-Roll',
            onPressed: reRoll,
            linearGradient: ColorValues.orangeButtonGradient,
          ),
        ),
      ],
    );
  }
}
