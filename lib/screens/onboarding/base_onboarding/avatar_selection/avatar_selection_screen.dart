import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/plain_button.dart';
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
  Future<bool> onBack() async => true;

  @override
  Future<bool> onNext() async => true;

  Future<void> regenProfile() async {
    if (ref.read(onboardingUserProvider).numRegenLeft < 1) return;

    final (String username, String profileImage) = await ref.read(onboardingServiceProvider).generateProfile();

    ref.read(onboardingUserProvider.notifier).setAnonymousUsername(username);
    ref.read(onboardingUserProvider.notifier).setAnonymousProfileImage(profileImage);
    ref.read(onboardingUserProvider.notifier).setNumRegenLeft(ref.read(onboardingUserProvider).numRegenLeft - 1);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingUser = ref.watch(onboardingUserProvider);

    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
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
                    fontSize: size.width * (24 / 414),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => AppColors.orangeTextGradient.createShader(bounds),
                      child: Text(
                        'anonymous ',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * (24 / 414),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Text(
                      'avatar',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * (24 / 414),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18, top: 18),
            child: SizedBox(
              width: size.width * 0.6,
              height: size.width * 0.6,
              child: Image.network(onboardingUser.anonymousProfileImage!),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.lightBlueTextGradient.createShader(bounds),
              child: Text(
                onboardingUser.anonymousUsername!.split(' ')[0],
                style: GoogleFonts.poppins(
                  fontSize: size.width * (24 / 414),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              ' ${onboardingUser.anonymousUsername!.split(' ')[1]}',
              style: GoogleFonts.poppins(
                fontSize: size.width * (24 / 414),
                letterSpacing: -0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Your avatar and anonymous name are what\n'
            'people see when they match with you. You can\n'
            'choose when and if you want to share your real\n'
            'name and profile picture with them.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: size.width * (14 / 414),
              letterSpacing: -0.3,
              color: AppColors.subtitle,
            ),
          ),
        ),
        Expanded(child: Container()),
        Text(
          'If you are unhappy with your randomly generated\n'
          'profile you can choose regenerate it up to five times.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: size.width * (12 / 414),
            letterSpacing: -0.3,
            color: AppColors.subtitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlainButton(
            text: 'Regenerate anonymous profile',
            onPressed: regenProfile,
            trailingIcon: SizedBox(
              width: 38,
              height: 32,
              child: Stack(
                children: [
                  SvgPicture.asset('assets/icons/dice.svg', width: 32, height: 32),
                  Positioned(
                    right: 0,
                    top: 2.5,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          ref.read(onboardingUserProvider).numRegenLeft.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            letterSpacing: -0.3,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            wrap: true,
          ),
        ),
      ],
    );
  }
}
