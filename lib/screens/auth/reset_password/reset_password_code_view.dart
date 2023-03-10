import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';
import 'package:socale/utils/validators.dart';

class ResetPasswordCodeView extends ResetPasswordView {
  final String email;
  final String password;

  const ResetPasswordCodeView({super.key, required this.password, required this.email});

  @override
  ResetPasswordViewState createState() => _ResetPasswordCodeViewState();
}

class _ResetPasswordCodeViewState extends ResetPasswordViewState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? code;

  void saveCode(String? value) => code = value;

  bool validateForm() {
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    if (validateForm()) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Headline(text: 'One more thing...'),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              Text(
                "We've sent a code the email address",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: (size.width * 0.034),
                  color: ColorValues.textSubtitle,
                ),
              ),
              Text(
                (widget as ResetPasswordCodeView).email,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.038),
                  color: ColorValues.textSubtitle,
                ),
              ),
              Text(
                'Please enter the code below',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: (size.width * 0.034),
                  color: ColorValues.textSubtitle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Form(
                key: formKey,
                child: PinCodeTextField(
                  length: 6,
                  appContext: context,
                  useHapticFeedback: true,
                  pinTheme: Themes.optPinTheme,
                  cursorColor: Colors.black,
                  hintCharacter: '0',
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  autoDismissKeyboard: true,
                  errorTextSpace: 20,
                  onSaved: saveCode,
                  onChanged: (value) {},
                  validator: Validators.validateCode,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
