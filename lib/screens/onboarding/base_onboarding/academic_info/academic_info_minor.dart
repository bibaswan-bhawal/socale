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
import 'package:socale/models/college/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

part 'academic_info_minor.g.dart';

@riverpod
Future<List<Minor>> fetchMinors(FetchMinorsRef ref) async {
  final disposeLink = ref.keepAlive();

  Future.delayed(const Duration(minutes: 10), () {
    disposeLink.close();
  });

  List<Minor> minors = [];

  final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
  String college = idToken.groups.first;

  final response = await http.get(Uri.parse('${const String.fromEnvironment('BACKEND_URL')}/api/get_minors'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
    'college': college,
  });

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((minor) {
      minors.add(Minor.fromJson(minor));
    });
  }

  return minors;
}

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

    final onboardingUser = ref.read(onboardingUserProvider);
    selectedMinors = onboardingUser.minors ?? [];
  }

  bool validateMinor() {
    final form = minorFormKey.currentState!;

    if (form.validate()) return saveMinor();

    return false; // false means don't progress to next screen
  }

  saveMinor() {
    final form = minorFormKey.currentState!;

    form.save();

    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setMinors(minors: selectedMinors);

    return true; // false means don't progress to next screen
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
    final minors = ref.watch(fetchMinorsProvider);

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
          child: minors.when(data: (majorsList) {
            return ChipCardFormField(
              emptyMessage: 'Add your major',
              searchHint: 'Search for your major',
              height: 160,
              horizontalPadding: 30,
              options: majorsList,
              initialValue: selectedMinors,
              onSaved: saveMinors,
            );
          }, error: (err, stack) {
            if(kDebugMode) print(err);
            return const SizedBox(
              width: double.infinity,
              height: 160,
              child: Center(
                child: Text('Error loading minor'),
              ),
            );
          }, loading: () {
            return const SizedBox(
              width: double.infinity,
              height: 160,
              child: Center(
                child: CircularProgressIndicator()
              ),
            );
          }),
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
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/illustration_2.png'),
          ),
        ),
      ],
    );
  }
}
