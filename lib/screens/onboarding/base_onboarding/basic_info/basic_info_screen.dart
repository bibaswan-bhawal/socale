import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/text_fields/form_fields/date_input_form_field.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_fields/date_input_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class BasicInfoScreen extends BaseOnboardingScreen {
  const BasicInfoScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends BaseOnboardingScreenState {
  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> dobFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> graduationDateFormKey = GlobalKey<FormState>();

  String? nameErrorMessage;

  String? firstName;
  String? lastName;

  DateTime? dateOfBirth;
  DateTime? graduationDate;

  void saveFirstName(String? value) => firstName = value;

  void saveLastName(String? value) => lastName = value;

  void saveDateOfBirth(DateTime? value) => dateOfBirth = value;

  void saveGraduationDate(DateTime? value) => graduationDate = value;

  bool validateForm() {
    final nameForm = nameFormKey.currentState!;

    if (nameForm.validate()) {
      saveForm();

      return true;
    } else {
      setState(() => nameErrorMessage = 'Please enter your first and last name.');
      return false;
    }
  }

  bool saveForm() {
    final nameForm = nameFormKey.currentState!;
    final dobForm = dobFormKey.currentState!;
    final graduationDateForm = graduationDateFormKey.currentState!;

    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    setState(() => nameErrorMessage = null);

    nameForm.save();
    dobForm.save();
    graduationDateForm.save();

    onboardingUser.setFirstName(firstName: firstName);
    onboardingUser.setLastName(lastName: lastName);
    onboardingUser.setDateOfBirth(dateOfBirth: dateOfBirth);
    onboardingUser.setGraduationDate(graduationDate: graduationDate);

    return true;
  }

  @override
  Future<bool> onNext() async => validateForm();

  @override
  Future<bool> onBack() async => saveForm();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final onboardingUser = ref.watch(onboardingUserProvider);

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'let\'s get to ',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                      ).createShader(bounds),
                      child: Text(
                        'know',
                        style: GoogleFonts.poppins(
                            fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Text(
                  'you better',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Form(
            key: nameFormKey,
            onChanged: () => setState(() => nameErrorMessage = null),
            child: DefaultInputForm(
              errorMessage: nameErrorMessage,
              children: [
                TextInputFormField(
                  hintText: 'First Name',
                  onSaved: saveFirstName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  initialValue: onboardingUser.firstName ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextInputFormField(
                  hintText: 'Last Name',
                  onSaved: saveLastName,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  initialValue: onboardingUser.lastName ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 36, right: 36),
          child: Form(
            key: dobFormKey,
            child: DefaultInputForm(
              labelText: 'Date of Birth',
              children: [
                DateInputFormField(
                  initialDate: onboardingUser.dateOfBirth ?? DateTime(2000),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onSaved: saveDateOfBirth,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 36, right: 36, top: 18),
          child: Form(
            key: graduationDateFormKey,
            child: DefaultInputForm(
              labelText: 'Graduation Date',
              children: [
                DateInputFormField(
                  dateMode: DatePickerDateMode.monthYear,
                  initialDate: onboardingUser.graduationDate ?? DateTime(DateTime.now().year, DateTime.june),
                  minimumDate: DateTime(1960),
                  maximumDate: DateTime(2100, DateTime.june),
                  onSaved: saveGraduationDate,
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
