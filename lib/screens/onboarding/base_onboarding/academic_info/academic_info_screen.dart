import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/components/section_tab_view/section_tab_bar.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';
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

  String? minorValidator(List<Minor>? value) => null;

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

    if (minorValidator(onboardingUser.minors) != null) {
      if (tabController.index == 0) {
        tabController.animateTo(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        await Future.delayed(const Duration(milliseconds: 300), () => minorFormKey.currentState!.validate());
      } else {
        minorFormKey.currentState!.validate();
      }

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final majorsProvider = ref.watch(fetchMajorsProvider);
    final minorProvider = ref.watch(fetchMinorsProvider);

    final onboardingUser = ref.watch(onboardingUserProvider);

    return Column(
      children: [
        Flexible(
          flex: 5,
          child: Hero(
            tag: 'academic_info_header',
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
        ),
        SectionTabBar(
          controller: tabController,
          tabs: const [SectionTab(title: 'Majors'), SectionTab(title: 'Minors')],
        ),
        Flexible(
          flex: 2,
          child: TabBarView(
            controller: tabController,
            children: [
              Form(
                key: majorFormKey,
                child: ChipCardFormField<Major>(
                  placeholder: 'Add your majors',
                  searchHint: 'Search for your majors',
                  horizontalPadding: 30,
                  initialValue: onboardingUser.majors,
                  changed: saveMajors,
                  validator: majorValidator,
                  options: majorsProvider.when(
                    data: (majors) => majors,
                    loading: () => null,
                    error: (err, stack) {
                      if (kDebugMode) print(err);
                      return [];
                    },
                  ),
                ),
              ),
              Form(
                key: minorFormKey,
                child: ChipCardFormField<Minor>(
                  placeholder: 'Add your minors',
                  searchHint: 'Search for your minors',
                  horizontalPadding: 20,
                  initialValue: onboardingUser.minors,
                  changed: saveMinors,
                  validator: minorValidator,
                  options: minorProvider.when(
                    data: (minors) => minors,
                    loading: () => null,
                    error: (err, stack) {
                      if (kDebugMode) print(err);
                      return [];
                    },
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
