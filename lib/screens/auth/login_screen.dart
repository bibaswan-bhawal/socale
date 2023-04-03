import 'package:flutter/foundation.dart';
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
import 'package:socale/types/auth/results/auth_flow_result.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<DefaultInputFormState> formKey = GlobalKey<DefaultInputFormState>();

  String? email;
  String? password;
  String? errorMessage;

  bool isLoading = false;

  void saveEmail(String? value) => email = value;

  void savePassword(String? value) => password = value;

  void goTo(AuthStepState step) {
    final authState = ref.read(authStateProvider.notifier);

    switch (step) {
      case AuthStepState.verifyEmail:
        authState.setAuthStep(newStep: step, email: email, password: password);
      default:
        authState.setAuthStep(newStep: step);
    }
  }

  bool validateForm() {
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();
      return true;
    }

    if (mounted) setState(() => errorMessage = 'Enter a valid email and password');
    return false;
  }

  Future<bool> attemptLogin() async {
    AuthFlowResult loginResult = await ref.read(authServiceProvider).signInUser(email!, password!);

    switch (loginResult) {
      case AuthFlowResult.success:
        return true;
      case AuthFlowResult.unverified:
        goTo(AuthStepState.verifyEmail);
      case AuthFlowResult.notAuthorized:
        setState(() => errorMessage = 'Incorrect password');
      case AuthFlowResult.userNotFound:
        if (mounted) SystemUI.showSnackBar(message: "We couldn't find your account, try signing up.", context: context);
      case AuthFlowResult.genericError:
        if (mounted) {
          SystemUI.showSnackBar(message: 'Something went wrong try again in a few minutes.', context: context);
        }
      default:
    }

    return false;
  }

  Future<bool> loginSuccessFlow() async {
    try {
      await ref.read(authServiceProvider).loginSuccessful();
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      ref.read(authServiceProvider).signOutUser();
      SystemUI.showSnackBar(message: 'Something went wrong try again in a few minutes.', context: context);
    }

    return false;
  }

  Future<void> onSubmit() async {
    setState(() => isLoading = true);

    if (!validateForm() && mounted) return setState(() => isLoading = false);
    if (!await attemptLogin() && mounted) return setState(() => isLoading = false);
    if (!await loginSuccessFlow() && mounted) return setState(() => isLoading = false);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              padding: EdgeInsets.only(top: size.height * 0.08 >= 54 ? size.height * 0.08 - 54 : 0),
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
                    TextSpan(
                      text: 'Welcome Back\n',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        letterSpacing: -0.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headline,
                      ),
                    ),
                    TextSpan(
                      text: 'Login to start matching',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        letterSpacing: -0.3,
                        color: AppColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 30),
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
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  prefixIcon: SvgIcon.asset('assets/icons/lock.svg', color: AppColors.textHint),
                  onSubmitted: (_) => onSubmit(),
                  onSaved: savePassword,
                  validator: Validators.validatePassword,
                ),
              ],
            ),
          ),
          const Spacer(),
          ActionGroup(
            actions: [
              LinkButton(
                onPressed: () => goTo(AuthStepState.register),
                prefixText: "Don't have an account?",
                text: 'Register',
              ),
              GradientButton(
                isLoading: isLoading,
                onPressed: onSubmit,
                text: 'Sign In',
                linearGradient: AppColors.orangeButtonGradient,
              ),
              LinkButton(
                onPressed: () => goTo(AuthStepState.forgotPassword),
                text: 'Forgot Password? ',
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
