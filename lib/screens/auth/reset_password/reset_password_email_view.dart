import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/forms/default_input_form.dart';
import 'package:socale/components/input_fields/text_input_field/text_form_field.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';
import 'package:socale/types/auth/results/auth_reset_password_result.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class ResetPasswordEmailView extends ResetPasswordView {
  final Function(String) saveEmail;
  final Function() startTimer;

  final String? email;

  final Duration timerDuration;

  const ResetPasswordEmailView({
    super.key,
    this.email,
    required this.saveEmail,
    required this.startTimer,
    required this.timerDuration,
  });

  @override
  ResetPasswordViewState createState() => _ResetPasswordEmailViewState();
}

class _ResetPasswordEmailViewState extends ResetPasswordViewState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? errorMessage;

  void saveEmail(String? value) => email = value;

  bool validateForm() {
    setState(() => errorMessage = null);

    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() => errorMessage = 'Please enter a valid email');
      return false;
    }
  }

  Future<bool> attemptSendEmail() async {
    final authService = ref.read(authServiceProvider);

    AuthResetPasswordResult result = await authService.sendResetPasswordCode(email!);

    switch (result) {
      case AuthResetPasswordResult.codeDeliverySuccessful:
        return true;
      case AuthResetPasswordResult.codeDeliveryFailure:
        if (mounted) {
          SystemUI.showSnackBar(message: 'There was problem sending your code, please try again', context: context);
        }

        return false;
      case AuthResetPasswordResult.tooManyRequests:
        if (mounted) SystemUI.showSnackBar(message: 'Too many requests, please try again later', context: context);
        return false;
      case AuthResetPasswordResult.userNotFound:
        setState(() => errorMessage = 'This email is not associated with any Socale account');
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

  bool shouldSendEmail() {
    final widget = this.widget as ResetPasswordEmailView;

    if (widget.email != email) return true;
    if (!(widget.timerDuration.inSeconds < 150)) return true;

    return false;
  }

  @override
  Future<bool> onNext() async {
    final widget = this.widget as ResetPasswordEmailView;

    if (!validateForm()) return false;
    if (!shouldSendEmail()) return true;
    if (!await attemptSendEmail()) return false;

    widget.startTimer();
    widget.saveEmail(email!);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Headline(text: 'Forgot Password?'),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            'To reset your password enter the email you \n'
            'used to sign up for Socale',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: (size.width * 0.034),
              color: AppColors.subtitle,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: DefaultInputForm(
                key: formKey,
                errorMessage: errorMessage,
                children: [
                  TextInputFormField(
                    hintText: 'Email Address',
                    initialValue: email ?? '',
                    textInputType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/email.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF808080),
                        BlendMode.srcIn,
                      ),
                      width: 16,
                    ),
                    onSaved: saveEmail,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
