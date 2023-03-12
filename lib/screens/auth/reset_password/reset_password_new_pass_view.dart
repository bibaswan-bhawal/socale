import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';
import 'package:socale/types/auth/auth_change_password.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class ResetPasswordNewPassView extends ResetPasswordView {
  final String email;
  final String tempPassword;

  const ResetPasswordNewPassView({super.key, required this.tempPassword, required this.email});

  @override
  ResetPasswordViewState createState() => _ResetPasswordNewPassViewState();
}

class _ResetPasswordNewPassViewState extends ResetPasswordViewState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? password;
  String? confirmPassword;
  String? errorMessage;

  void savePassword(String? value) => password = value;

  void saveConfirmPassword(String? value) => confirmPassword = value;

  bool validateForm() {
    setState(() => errorMessage = null);

    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();

      if (password != confirmPassword) {
        setState(() => errorMessage = 'Passwords do not match');
        return false;
      }

      return true;
    } else {
      setState(() => errorMessage = 'Please enter a valid password');
      return false;
    }
  }

  Future<bool> attemptResetPassword() async {
    final authService = ref.read(authServiceProvider);

    final result = await authService.changePassword(
      email: (widget as ResetPasswordNewPassView).email,
      currentPassword: (widget as ResetPasswordNewPassView).tempPassword,
      newPassword: password!,
    );

    switch (result) {
      case AuthChangePasswordResult.success:
        return true;
      case AuthChangePasswordResult.invalidPassword:
        if (kDebugMode) print('Password Change - Invalid password');
        break;
      case AuthChangePasswordResult.userNotFound:
        if (kDebugMode) print('Password Change - User not found');
        break;
      case AuthChangePasswordResult.timeout:
        if (kDebugMode) print('Password Change - Timeout');
        break;
      case AuthChangePasswordResult.notAuthorized:
        if (kDebugMode) print('Password Change - Not authorized');
        break;
      case AuthChangePasswordResult.tooManyRequests:
        if (kDebugMode) print('Password Change - Too many requests');
        break;
      default:
        break;
    }

    if (mounted) {
      SystemUI.showSnackBar(
        message: 'There was a problem changing your password,\ntry again later.',
        context: context,
      );
    }

    return false;
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
        const Headline(text: 'New Password'),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              Text(
                'Enter your new password for',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: (size.width * 0.034),
                  color: ColorValues.textSubtitle,
                ),
              ),
              Text(
                (widget as ResetPasswordNewPassView).email,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.038),
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
                child: DefaultInputForm(
                  errorMessage: errorMessage,
                  children: [
                    TextInputFormField(
                      hintText: 'New Password',
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.password],
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/lock.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF808080),
                          BlendMode.srcIn,
                        ),
                        width: 16,
                      ),
                      isObscured: true,
                      onSaved: savePassword,
                      validator: Validators.validatePassword,
                    ),
                    TextInputFormField(
                      hintText: 'Confirm Password',
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/lock.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF808080),
                          BlendMode.srcIn,
                        ),
                        width: 16,
                      ),
                      isObscured: true,
                      onSaved: saveConfirmPassword,
                      validator: Validators.validatePassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
