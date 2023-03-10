import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';
import 'package:socale/utils/validators.dart';

class ResetPasswordNewPassView extends ResetPasswordView {
  final String email;
  final Function(String) savePassword;

  const ResetPasswordNewPassView({super.key, required this.savePassword, required this.email});

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

  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    if (validateForm()) {
      (widget as ResetPasswordNewPassView).savePassword(password!);
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
        const Headline(text: 'New Password'),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              Text(
                'Change password for',
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
