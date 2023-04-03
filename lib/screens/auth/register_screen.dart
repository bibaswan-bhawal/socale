import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/forms/default_input_form.dart';
import 'package:socale/components/input_fields/text_input_field/text_form_field.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/styles.dart';
import 'package:socale/types/auth/results/auth_flow_result.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';
import 'package:socale/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TapGestureRecognizer tosTextGestureRecognizer = TapGestureRecognizer();
  TapGestureRecognizer privacyTextGestureRecognizer = TapGestureRecognizer();

  bool isLoading = false;

  String? errorMessage;

  String? email;
  String? password;
  String? confirmPassword;

  saveEmail(String? value) => email = value;

  savePassword(String? value) => password = value;

  saveConfirmPassword(String? value) => confirmPassword = value;

  goTo(AuthStepState step) {
    final authState = ref.read(authStateProvider.notifier);

    switch (step) {
      case AuthStepState.verifyEmail:
        authState.setAuthStep(newStep: step, email: email, password: password);
      default:
        authState.setAuthStep(newStep: step);
    }
  }

  Future<void> onClickRegister() async {
    final form = formKey.currentState!;
    if (isLoading) return;
    setState(() => isLoading = true);

    if (form.validate()) {
      setState(() => errorMessage = null);

      form.save();

      if (password != confirmPassword) {
        showFormError("Passwords don't match");
        return;
      }

      final result = await ref.read(authServiceProvider).signUpUser(email!, password!);

      switch (result) {
        case AuthFlowResult.success:
          if (mounted) await ref.read(authServiceProvider).loginSuccessful();
          return;
        case AuthFlowResult.unverified:
          goTo(AuthStepState.verifyEmail);
        case AuthFlowResult.notAuthorized:
          showFormError('Looks like you already have an account. Try signing in.');
        default:
          showFormError('Something went wrong. Please try again.');
      }
    } else {
      showFormError('Enter a valid email and confirm passwords match');
    }

    setState(() => isLoading = false);
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message, textAlign: TextAlign.center));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showFormError(String message) => setState(() {
        errorMessage = message;
        isLoading = false;
      });

  @override
  void initState() {
    super.initState();

    tosTextGestureRecognizer.onTap =
        () async => await launchUrl(Uri.parse('http://socale.co/privacypolicy'), mode: LaunchMode.externalApplication);
    privacyTextGestureRecognizer.onTap =
        () async => await launchUrl(Uri.parse('http://socale.co/tos'), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    tosTextGestureRecognizer.dispose();
    privacyTextGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double topPadding = (size.height * 0.08 >= 54) ? size.height * 0.08 - 54 : 0;
    final double bottomPadding = 40 - MediaQuery.of(context).viewPadding.bottom;

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: SvgIcon.asset('assets/icons/back.svg', width: 24, height: 24),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: SvgPicture.asset('assets/logo/color_logo.svg', width: 150),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Hello There\n', style: AppTextStyle.h1),
                    TextSpan(text: 'Sign up to start matching', style: AppTextStyle.h2),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 30, right: 30),
            child: DefaultInputForm(
              key: formKey,
              errorMessage: errorMessage,
              children: [
                TextInputFormField(
                  hintText: 'Email Address',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: SvgIcon.asset('assets/icons/email.svg', color: AppColors.textHint),
                  onSaved: saveEmail,
                  validator: Validators.validateEmail,
                ),
                TextInputFormField(
                  hintText: 'Password',
                  isObscured: true,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  prefixIcon: SvgIcon.asset('assets/icons/lock.svg', color: AppColors.textHint),
                  onSaved: savePassword,
                  validator: Validators.validatePassword,
                ),
                TextInputFormField(
                  hintText: 'Confirm Password',
                  isObscured: true,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  prefixIcon: SvgIcon.asset('assets/icons/lock.svg', color: AppColors.textHint),
                  onSaved: saveConfirmPassword,
                  validator: Validators.validatePassword,
                ),
              ],
            ),
          ),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.roboto(fontSize: 12, letterSpacing: -0.3, color: AppColors.subtitle),
                children: [
                  const TextSpan(text: 'By signing up you agree to the Socale\n'),
                  TextSpan(
                    text: 'Terms of service',
                    recognizer: tosTextGestureRecognizer,
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                  const TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Privacy Policy',
                    recognizer: privacyTextGestureRecognizer,
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: ActionGroup(
              actions: [
                LinkButton(
                  text: 'Sign In',
                  prefixText: 'Already have an account?',
                  onPressed: () => goTo(AuthStepState.login),
                ),
                GradientButton(
                  isLoading: isLoading,
                  onPressed: onClickRegister,
                  text: 'Create an Account',
                  linearGradient: AppColors.blueButtonGradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
