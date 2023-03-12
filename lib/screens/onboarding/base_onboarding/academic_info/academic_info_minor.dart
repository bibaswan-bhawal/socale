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
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/academic_info/academic_info_header.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

//
// @riverpod
// Future<List<Minor>> fetchMinors(FetchMinorsRef ref) async {
//   final disposeLink = ref.keepAlive();
//
//   Future.delayed(const Duration(minutes: 10), () {
//     disposeLink.close();
//   });
//
//   List<Minor> minors = [];
//
//   final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
//   String college = idToken.groups.first;
//
//   final response = await http.get(Uri.parse('${const String.fromEnvironment('BACKEND_URL')}/api/get_minors'), headers: {
//     HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
//     'college': college,
//   });
//
//   if (response.statusCode == 200) {
//     final body = jsonDecode(response.body);
//
//     body.forEach((minor) {
//       minors.add(Minor.fromJson(minor));
//     });
//   }
//
//   return minors;
// }

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
//   key: minorFormKey,
//   child: minors.when(
//     data: (majorsList) {
//       return ChipCardFormField(
//         emptyMessage: 'Add your major',
//         searchHint: 'Search for your major',
//         height: 160,
//         horizontalPadding: 30,
//         options: majorsList,
//         initialValue: selectedMinors,
//         onSaved: saveMinors,
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
