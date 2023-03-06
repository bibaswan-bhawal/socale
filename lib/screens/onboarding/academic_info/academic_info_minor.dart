import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/options/majors/ucsd_majors.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';

class AcademicInfoMinorScreen extends OnboardingScreen {
  const AcademicInfoMinorScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => _AcademicInfoMinorScreenState();
}

class _AcademicInfoMinorScreenState extends OnboardingScreenState {
  GlobalKey<FormState> minorFormKey = GlobalKey<FormState>();

  List<String>? minors = [];

  saveMinors(List<String>? value) => minors = value;

  @override
  void initState() {
    super.initState();

    final onboardingUser = ref.read(onboardingUserProvider);
    minors = onboardingUser.minors ?? [];
  }

  bool validateMinor() {
    final form = minorFormKey.currentState!;

    if (form.validate()) return saveMinor();

    return false;
  }

  saveMinor() {
    final form = minorFormKey.currentState!;

    form.save();

    final onboardingUser = ref.read(onboardingUserProvider);

    onboardingUser.minors = minors;

    ref.read(onboardingUserProvider.notifier).dispose();
    return false;
  }

  @override
  Future<bool> onBack() async => saveMinor();

  @override
  Future<bool> onNext() async => validateMinor();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Hero(
            tag: 'academic_info_header',
            child: _Header(),
          ),
        ),
        Form(
          key: minorFormKey,
          child: ChipCardFormField(
            emptyMessage: 'Add your Minor',
            searchHint: 'Search for your Minor',
            height: 160,
            horizontalPadding: 30,
            options: ucsdMajors,
            initialValue: minors,
            onSaved: saveMinors,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Text(
                  'let\'s find you some ',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                  ).createShader(bounds),
                  child: Text(
                    'classmates',
                    style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/illustration_2.png'),
          ),
        ),
      ],
    );
  }
}
