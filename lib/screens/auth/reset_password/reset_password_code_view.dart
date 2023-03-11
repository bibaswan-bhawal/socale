import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';
import 'package:socale/types/auth/auth_reset_password.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class ResetPasswordCodeView extends ResetPasswordView {
  final String email;
  final Function(String) tempPassword;

  const ResetPasswordCodeView({super.key, required this.tempPassword, required this.email});

  @override
  ResetPasswordViewState createState() => _ResetPasswordCodeViewState();
}

class _ResetPasswordCodeViewState extends ResetPasswordViewState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? code;

  String? tempPassword;

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

  // Generate a random 12 character password
  String generateTempPassword() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)(*&^%#@!';
    return List.generate(12, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<bool> attemptResetPassword() async {
    final authService = ref.read(authServiceProvider);

    tempPassword = generateTempPassword();

    final result = await authService.confirmResetPassword(
      email: (widget as ResetPasswordCodeView).email,
      newPassword: tempPassword!,
      code: code!,
    );

    switch (result) {
      case AuthResetPasswordResult.success:
        (widget as ResetPasswordCodeView).tempPassword(tempPassword!);
        return true;
      case AuthResetPasswordResult.codeMismatch:
        if (mounted) SystemUI.showSnackBar(message: 'The code you entered is incorrect', context: context);
        return false;
      case AuthResetPasswordResult.expiredCode:
        if (mounted) SystemUI.showSnackBar(message: 'The code you entered has expired', context: context);
        return false;
      case AuthResetPasswordResult.tooManyRequests:
        if (mounted) SystemUI.showSnackBar(message: 'Too many requests, please try again later', context: context);
        return false;
      default:
        if (mounted) SystemUI.showSnackBar(message: 'Something went wrong, please try again later', context: context);
        return false;
    }
  }

  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    if (!validateForm()) return false;
    if (!await attemptResetPassword()) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Headline(text: 'Just to confirm...'),
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
