import 'dart:convert';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_header.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class AcademicInfoMajorScreen extends BaseOnboardingScreen {
  const AcademicInfoMajorScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _AcademicInfoMajorScreenState();
}

class _AcademicInfoMajorScreenState extends BaseOnboardingScreenState {
  GlobalKey<FormState> majorFormKey = GlobalKey<FormState>();

  List<Major>? selectedMajors = [];

  saveMajors(List<dynamic>? value) => selectedMajors = value?.cast<Major>();

  @override
  void initState() {
    super.initState();

    final onboardingUser = ref.read(onboardingUserProvider);
    selectedMajors = onboardingUser.majors ?? [];
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

    onboardingUser.setMajors(majors: selectedMajors);
    return true;
  }

  @override
  Future<bool> onBack() async => saveMajor();

  @override
  Future<bool> onNext() async => validateMajor();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Hero(
            tag: 'academic_info_header',
            child: AcademicInfoHeader(),
          ),
        ),
      ],
    );
  }
}

// Form(
//   key: majorFormKey,
//   child: majors.when(
//     data: (majorsList) {
//       return ChipCardFormField(
//         emptyMessage: 'Add your major',
//         searchHint: 'Search for your major',
//         height: 160,
//         horizontalPadding: 30,
//         options: majorsList,
//         initialValue: selectedMajors,
//         onSaved: saveMajors,
//       );
//     },
//     error: (err, stack) {
//       if (kDebugMode) print(err);
//       return const SizedBox(
//         width: double.infinity,
//         height: 160,
//         child: Center(
//           child: Text('Error loading minor'),
//         ),
//       );
//     },
//     loading: () {
//       return const SizedBox(
//         width: double.infinity,
//         height: 160,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     },
//   ),
// ),
