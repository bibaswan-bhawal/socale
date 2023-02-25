import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/options/majors/ucsd_majors.dart';
import 'package:socale/resources/colors.dart';

class AcademicInfoPage extends ConsumerStatefulWidget {
  final OnboardingUser onboardingUser;

  const AcademicInfoPage({
    super.key,
    required this.onboardingUser,
  });

  @override
  ConsumerState<AcademicInfoPage> createState() => AcademicInfoPageState();
}

class AcademicInfoPageState extends ConsumerState<AcademicInfoPage> {
  PageController pageController = PageController();

  GlobalKey<FormState> majorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> minorFormKey = GlobalKey<FormState>();

  late int currentPage;

  List<String>? majors = [];
  List<String>? minors = [];

  saveMajors(List<String>? value) => majors = value;

  saveMinors(List<String>? value) => minors = value;

  @override
  void initState() {
    super.initState();

    currentPage = pageController.initialPage;

    majors = widget.onboardingUser.majors ?? [];
    minors = widget.onboardingUser.minors ?? [];

    pageController.addListener(() {
      if (currentPage != pageController.page!.round()) {
        setState(() => currentPage = pageController.page!.round());
      }
    });
  }

  bool validateMajor() {
    final form = majorFormKey.currentState!;

    if (form.validate()) {
      form.save();

      widget.onboardingUser.majors;
      return true;
    }

    return false;
  }

  next() {
    if (currentPage == 1) return;
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: emphasized);
  }

  previous() {
    if (currentPage == 0) return;
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: emphasized);
  }

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
                    style: GoogleFonts.poppins(
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Center(
            child: Image.asset('assets/illustrations/onboarding_intro/cover_page_4.png'),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
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
              Form(
                key: minorFormKey,
                child: ChipCardFormField(
                  emptyMessage: 'Add your minor',
                  searchHint: 'Search for your minor',
                  height: 160,
                  horizontalPadding: 30,
                  options: ucsdMajors,
                  initialValue: minors,
                  onSaved: saveMinors,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
