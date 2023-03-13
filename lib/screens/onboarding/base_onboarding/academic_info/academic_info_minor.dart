import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_header.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AcademicInfoMinorScreen extends BaseOnboardingScreen {
  const AcademicInfoMinorScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AcademicInfoMinorScreenState();
}

class _AcademicInfoMinorScreenState extends BaseOnboardingScreenState {
  GlobalKey<FormState> minorFormKey = GlobalKey<FormState>();

  List<Minor>? selectedMinors = [];

  saveMinors(List<dynamic>? value) => selectedMinors = value?.cast<Minor>();

  @override
  void initState() {
    super.initState();

    selectedMinors = ref.read(onboardingUserProvider).minors ?? [];
  }

  bool validateMinor() {
    final form = minorFormKey.currentState!;
    if (form.validate()) return saveMinor();
    return false;
  }

  bool saveMinor() {
    minorFormKey.currentState!.save();
    ref.read(onboardingUserProvider.notifier).setMinors(minors: selectedMinors);
    return true;
  }

  @override
  Future<bool> onBack() async => saveMinor();

  @override
  Future<bool> onNext() async {
    validateMinor();

    if (kDebugMode) {
      print(ref.read(onboardingUserProvider));
    }

    ref.read(onboardingUserProvider.notifier).disposeState();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final minorsProvider = ref.watch(fetchMinorsProvider);

    return Column(
      children: [
        const Expanded(
          child: Hero(
            tag: 'academic_info_header',
            child: AcademicInfoHeader(),
          ),
        ),
        Form(
          key: minorFormKey,
          child: ChipCardFormField(
            emptyMessage: 'Add your major',
            searchHint: 'Search for your major',
            height: 160,
            horizontalPadding: 30,
            options: minorsProvider.when(
              data: (minors) {
                // Handle when data is received
                return minors;
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
            initialValue: selectedMinors,
            onSaved: saveMinors,
          ),
        ),
      ],
    );
  }
}
