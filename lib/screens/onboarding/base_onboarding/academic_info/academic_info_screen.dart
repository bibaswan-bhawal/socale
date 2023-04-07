import 'package:flutter/material.dart';
import 'package:socale/components/input_fields/chip_card_input_field/chip_card_form_field.dart';
import 'package:socale/components/section_tab_view/section_tab_bar.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/models/options/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/select_majors_screen.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/select_minors_screen.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AcademicInfoScreen extends BaseOnboardingScreen {
  const AcademicInfoScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AcademicInfoMajorScreenState();
}

class _AcademicInfoMajorScreenState extends BaseOnboardingScreenState with SingleTickerProviderStateMixin {
  late TabController tabController;

  GlobalKey<FormState> majorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> minorFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  void saveMajors(value) {
    ref.read(onboardingUserProvider.notifier).setMajors(value);
    majorFormKey.currentState!.validate();
  }

  void saveMinors(value) {
    ref.read(onboardingUserProvider.notifier).setMinors(value);
    minorFormKey.currentState!.validate();
  }

  String? majorValidator(List<Major>? value) =>
      (value == null || value.isEmpty) ? 'Please select at least one major' : null;

  @override
  Future<bool> onBack() async => true;

  @override
  Future<bool> onNext() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    if (majorValidator(onboardingUser.majors) != null) {
      if (tabController.index == 1) {
        tabController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        await Future.delayed(const Duration(milliseconds: 300), () => majorFormKey.currentState!.validate());
      } else {
        majorFormKey.currentState!.validate();
      }

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final onboardingUser = ref.watch(onboardingUserProvider);

    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 36),
                child: GradientHeadline(
                  headlinePlain: 'Let’s find you some',
                  headlineColored: 'classmates',
                  newLine: true,
                ),
              ),
              Expanded(child: Image.asset('assets/illustrations/illustration_2.png')),
            ],
          ),
        ),
        SectionTabBar(
          controller: tabController,
          tabs: const [SectionTab(title: 'Majors'), SectionTab(title: 'Minors')],
        ),
        Container(
          height: size.height * 0.28,
          constraints: const BoxConstraints(maxHeight: 200, minHeight: 150),
          child: TabBarView(
            controller: tabController,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 36),
                child: Form(
                  key: majorFormKey,
                  child: ChipCardFormField<Major>(
                    placeholder: 'Add your majors',
                    initialValue: onboardingUser.majors,
                    onChanged: saveMajors,
                    validator: majorValidator,
                    inputPicker: MajorPickerScreenBuilder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 36),
                child: Form(
                  key: minorFormKey,
                  child: ChipCardFormField<Minor>(
                    placeholder: 'Add your minors',
                    onChanged: saveMinors,
                    initialValue: onboardingUser.minors,
                    inputPicker: MinorPickerScreenBuilder(),
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
