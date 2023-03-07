import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/options/majors/ucsd_majors.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AcademicInfoMajorScreen extends BaseOnboardingScreen {
  const AcademicInfoMajorScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AcademicInfoMajorScreenState();
}

class _AcademicInfoMajorScreenState extends BaseOnboardingScreenState {
  GlobalKey<FormState> majorFormKey = GlobalKey<FormState>();

  List<String>? majors = [];

  saveMajors(List<String>? value) => majors = value;

  @override
  void initState() {
    super.initState();

    final onboardingUser = ref.read(onboardingUserProvider);
    majors = onboardingUser.majors ?? [];
  }

  bool validateMajor() {
    final form = majorFormKey.currentState!;

    if (form.validate()) return saveMajor();

    return false;
  }

  bool saveMajor() {
    final form = majorFormKey.currentState!;
    form.save();

    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setMajors(majors: majors);
    return true;
  }

  @override
  Future<bool> onBack() async => saveMajor();

  @override
  Future<bool> onNext() async => validateMajor();

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
          key: majorFormKey,
          child: ChipCardFormField(
            emptyMessage: 'Add your major',
            searchHint: 'Search for your major',
            height: 160,
            horizontalPadding: 30,
            options: ucsdMajors,
            initialValue: majors,
            onSaved: saveMajors,
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
