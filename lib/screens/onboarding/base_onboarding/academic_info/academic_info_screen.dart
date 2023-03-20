import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/components/section_tab_view/section_tab_bar.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_header.dart';
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

  List<Major>? selectedMajors = [];
  List<Minor>? selectedMinors = [];

  saveMajors(List<dynamic>? value) => selectedMajors = value?.cast<Major>();

  saveMinors(List<dynamic>? value) => selectedMinors = value?.cast<Minor>();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    // Save all on tab change
    tabController.addListener(() {
      if (tabController.index == 0) {
        saveMinor();
      } else {
        saveMajor();
      }
    });

    selectedMajors = ref.read(onboardingUserProvider).majors ?? []; // Get selected majors from onboarding state
    selectedMinors = ref.read(onboardingUserProvider).minors ?? []; // Get selected minors from onboarding state
  }

  bool validateMajor() {
    final majorForm = majorFormKey.currentState;
    if (majorForm == null) return true;
    if (majorForm.validate()) return saveMajor();
    return false;
  }

  bool validateMinor() {
    final minorForm = minorFormKey.currentState;
    if (minorForm == null) return true;
    if (minorForm.validate()) return saveMinor();
    return false;
  }

  bool saveMajor() {
    final majorForm = majorFormKey.currentState;
    if (majorForm == null) return true;
    majorForm.save();
    ref.read(onboardingUserProvider.notifier).setMajors(selectedMajors);
    return true;
  }

  bool saveMinor() {
    final minorForm = minorFormKey.currentState;
    if (minorForm == null) return true;
    minorForm.save();
    ref.read(onboardingUserProvider.notifier).setMinors(selectedMinors);
    return true;
  }

  @override
  Future<bool> onBack() async => saveMajor() && saveMinor();

  @override
  Future<bool> onNext() async => validateMajor() && validateMinor();

  @override
  Widget build(BuildContext context) {
    final majorsProvider = ref.watch(fetchMajorsProvider);
    final minorProvider = ref.watch(fetchMinorsProvider);

    return Column(
      children: [
        const Flexible(flex: 5, child: Hero(tag: 'academic_info_header', child: AcademicInfoHeader())),
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
                child: ChipCardFormField(
                  placeholder: 'Add your majors',
                  searchHint: 'Search for your majors',
                  horizontalPadding: 30,
                  initialValue: selectedMajors,
                  onSaved: saveMajors,
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
                child: ChipCardFormField(
                  placeholder: 'Add your minors',
                  searchHint: 'Search for your minors',
                  horizontalPadding: 30,
                  initialValue: selectedMinors,
                  onSaved: saveMinors,
                  options: minorProvider.when(
                    data: (majors) => majors,
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
