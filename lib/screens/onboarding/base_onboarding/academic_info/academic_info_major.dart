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
import 'package:socale/models/college/major.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

part 'academic_info_major.g.dart';

@riverpod
Future<List<Major>> fetchMajors(FetchMajorsRef ref) async {
  final disposeLink = ref.keepAlive();

  Future.delayed(const Duration(minutes: 10), () {
    disposeLink.close();
  });

  List<Major> majors = [];

  final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
  String college = idToken.groups.first;

  final response = await http.get(Uri.parse('${const String.fromEnvironment('BACKEND_URL')}/api/get_majors'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
    'college': college,
  });

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((major) {
      majors.add(Major.fromJson(major));
    });
  }

  return majors;
}


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
    final majors = ref.watch(fetchMajorsProvider);

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
          child: majors.when(data: (majorsList) {
            return ChipCardFormField(
              emptyMessage: 'Add your major',
              searchHint: 'Search for your major',
              height: 160,
              horizontalPadding: 30,
              options: majorsList,
              initialValue: selectedMajors,
              onSaved: saveMajors,
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
                    style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white,),
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
