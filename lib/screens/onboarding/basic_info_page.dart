import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/text_fields/form_fields/date_input_form_field.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_fields/date_input_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/resources/colors.dart';

class BasicInfoPage extends ConsumerStatefulWidget {
  final OnboardingUser onboardingUser;

  const BasicInfoPage({super.key, required this.onboardingUser});

  @override
  ConsumerState<BasicInfoPage> createState() => BasicInfoPageState();
}

class BasicInfoPageState extends ConsumerState<BasicInfoPage> {
  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> dobFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> graduationDateFormKey = GlobalKey<FormState>();

  String? nameErrorMessage;
  String? dateOfBirthErrorMessage;
  String? graduationDateErrorMessage;

  String? firstName;
  String? lastName;

  DateTime? dateOfBirth;
  DateTime? graduationDate;

  saveFirstName(String? value) => firstName = value;

  saveLastName(String? value) => lastName = value;

  saveDateOfBirth(DateTime? value) => dateOfBirth = value;

  saveGraduationDate(DateTime? value) => graduationDate = value;

  bool validateForm() {
    final nameForm = nameFormKey.currentState!;
    final dobForm = dobFormKey.currentState!;
    final graduationDateForm = graduationDateFormKey.currentState!;

    if (nameForm.validate()) {
      nameForm.save();
      dobForm.save();
      graduationDateForm.save();

      widget.onboardingUser.firstName = firstName;
      widget.onboardingUser.lastName = lastName;
      widget.onboardingUser.dateOfBirth = dateOfBirth;
      widget.onboardingUser.graduationDate = graduationDate;

      return true;
    } else {
      setState(() => nameErrorMessage = 'Please enter your first and last name.');
      return false;
    }
  }

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
                            fontSize: size.width * 0.058,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
            child: DefaultInputForm(
              errorMessage: nameErrorMessage,
              children: [
                TextInputFormField(
                  hintText: 'First Name',
                  onSaved: saveFirstName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  initialValue: widget.onboardingUser.firstName ?? '',
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
                  initialValue: widget.onboardingUser.lastName ?? '',
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
              errorMessage: dateOfBirthErrorMessage,
              children: [
                DateInputFormField(
                  initialDate: widget.onboardingUser.dateOfBirth ?? DateTime(2000),
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
              errorMessage: graduationDateErrorMessage,
              children: [
                DateInputFormField(
                  dateMode: DatePickerDateMode.monthYear,
                  initialDate: widget.onboardingUser.graduationDate ??
                      DateTime(DateTime.now().year, DateTime.june),
                  minimumDate: DateTime(1960),
                  maximumDate: DateTime(2100, DateTime.june),
                  onSaved: saveGraduationDate,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
