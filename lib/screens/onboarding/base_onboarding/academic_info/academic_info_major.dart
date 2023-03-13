import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_header.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AcademicInfoMajorScreen extends BaseOnboardingScreen {
  const AcademicInfoMajorScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AcademicInfoMajorScreenState();
}

class _AcademicInfoMajorScreenState extends BaseOnboardingScreenState {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Major>? selectedMajors = [];

  saveMajors(List<dynamic>? value) => selectedMajors = value?.cast<Major>();

  @override
  void initState() {
    super.initState();

    final onboardingUser = ref.read(onboardingUserProvider);
    selectedMajors = onboardingUser.majors ?? [];
  }

  bool validateMajor() {
    final form = formKey.currentState!;

    if (form.validate()) return saveMajor();

    return false;
  }

  bool saveMajor() {
    final form = formKey.currentState!;
    form.save();

    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setMajors(majors: selectedMajors);
    return true;
  }

  @override
  Future<bool> onBack() async => saveMajor();

  @override
  Future<bool> onNext() async => validateMajor();

  @override
  Widget build(BuildContext context) {
    final majorsProvider = ref.watch(fetchMajorsProvider);

    return Column(
      children: [
        const Expanded(
          child: Hero(
            tag: 'academic_info_header',
            child: AcademicInfoHeader(),
          ),
        ),
        Form(
          key: formKey,
          child: ChipCardFormField(
            emptyMessage: 'Add your major',
            searchHint: 'Search for your major',
            height: 160,
            horizontalPadding: 30,
            options: majorsProvider.when(
              data: (majors) {
                // Handle when data is received
                return majors;
              },
              error: (err, stack) {
                // Handle when error is received
                if (kDebugMode) print(err);
                return []; // empty list shows error message
              },
              loading: () {
                // Handle when loading
                return null; // null list shows loading indicator
              },
            ),
            initialValue: selectedMajors,
            onSaved: saveMajors,
          ),
        ),
      ],
    );
  }
}
