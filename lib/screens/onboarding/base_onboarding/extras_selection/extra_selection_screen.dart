import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';
import 'package:socale/utils/system_ui.dart';

class ExtraSelectionScreen extends BaseOnboardingScreen {
  const ExtraSelectionScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _ExtraSelectionScreenState();
}

class _ExtraSelectionScreenState extends BaseOnboardingScreenState {
  void saveLanguages(value) => ref.read(onboardingUserProvider.notifier).setLanguages(value);

  void saveInterests(value) => ref.read(onboardingUserProvider.notifier).setInterests(value);

  void saveClubs(value) => ref.read(onboardingUserProvider.notifier).setClubs(value);

  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUIDark();

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
                  'Add more stuff',
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
                    Text(
                      'to your ',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * (24 / 414),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => AppColors.orangeTextGradient.createShader(bounds),
                      child: Text(
                        'profile',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * (24 / 414),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 48, right: 48, top: (size.height * 0.03).clamp(8, 36)),
            child: Form(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 124 / 165,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  // GridItemFormField<Language>(
                  //   title: 'Languages',
                  //   icon: Image.asset('assets/illustrations/illustration_10.png'),
                  //   borderGradient: AppColors.purpleGradient,
                  //   onChanged: saveLanguages,
                  //   initialData: onboardingUser.languages,
                  //   inputPicker: ListInputPickerBuilder<Language>(
                  //     searchHintText: 'Search languages',
                  //     data: languagesProvider.when(
                  //       data: (data) => data,
                  //       error: (err, stack) => [],
                  //       loading: () => null,
                  //     ),
                  //   ),
                  // ),
                  // GridItemFormField<Interest>(
                  //   title: 'Interests',
                  //   icon: Image.asset('assets/illustrations/illustration_9.png'),
                  //   borderGradient: AppColors.lightBlueGradient,
                  //   initialData: onboardingUser.interests,
                  //   onChanged: saveInterests,
                  //   inputPicker: CategoricalInputPickerBuilder<Interest>(
                  //     searchHintText: 'Search Interests',
                  //     data: interestsProvider.when(
                  //       data: (data) => data,
                  //       error: (err, stack) => [],
                  //       loading: () => null,
                  //     ),
                  //   ),
                  // ),
                  // GridItemFormField<Club>(
                  //   title: 'clubs',
                  //   icon: Image.asset('assets/illustrations/illustration_11.png'),
                  //   borderGradient: AppColors.orangeGradient,
                  //   initialData: onboardingUser.clubs,
                  //   onChanged: saveClubs,
                  //   inputPicker: CategoricalInputPickerBuilder<Club>(
                  //     searchHintText: 'Search clubs',
                  //     data: clubsProvider.when(
                  //       data: (data) => data,
                  //       error: (err, stack) => [],
                  //       loading: () => null,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        Text(
          'You can add or change anything about your\n'
          'profile from the account tab at any time.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppColors.subtitle,
          ),
        ),
      ],
    );
  }
}
