import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/text_field_icons.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? errorMessage;

  bool isLoading = false;

  void saveEmail(String? value) => email = value;

  void savePassword(String? value) => password = value;

  void goTo(AuthStep step) {
    final authState = ref.read(authStateProvider.notifier);

    switch (step) {
      case AuthStep.verifyEmail:
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
        goTo(AuthStep.verifyEmail);
      case AuthFlowResult.notAuthorized:
        setState(() => errorMessage = 'Incorrect password');
      case AuthFlowResult.userNotFound:
        if (mounted) SystemUI.showSnackBar(message: "We couldn't find your account, try signing up.", context: context);
      case AuthFlowResult.genericError:
        if (mounted) SystemUI.showSnackBar(message: 'Something went wrong try again in a few minutes.', context: context);
      default:
    }

    return false;
  }

  Future<bool> loginSuccessFlow() async {
    try {
      await ref.read(authServiceProvider).loginSuccessful(email);
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: SizedBox(
                width: 24,
                height: 24,
                child: InkResponse(
                  radius: 20,
                  splashFactory: InkRipple.splashFactory,
                  child: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.fill),
                  onTap: () => Navigator.maybePop(context),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.08 >= 54 ? size.height * 0.08 - 54 : 0),
            child: SvgPicture.asset('assets/logo/color_logo.svg', width: 150),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Login to start matching',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 30),
            child: Form(
              key: formKey,
              child: DefaultInputForm(
                errorMessage: errorMessage,
                children: [
                  TextInputFormField(
                    hintText: 'Email Address',
                    textInputType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    prefixIcon: AppAssets.textFieldIcon('assets/icons/email.svg'),
                    onSaved: saveEmail,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  TextInputFormField(
                    hintText: 'Password',
                    textInputType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    prefixIcon: AppAssets.textFieldIcon('assets/icons/lock.svg'),
                    isObscured: true,
                    onSaved: savePassword,
                    onSubmitted: (_) => onSubmit(),
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          ActionGroup(
            actions: [
              LinkButton(
                onPressed: () => goTo(AuthStep.register),
                prefixText: "Don't have an account?",
                text: 'Register',
              ),
              GradientButton(
                isLoading: isLoading,
                onPressed: onSubmit,
                text: 'Sign In',
                linearGradient: ColorValues.orangeButtonGradient,
              ),
              LinkButton(
                onPressed: () => goTo(AuthStep.forgotPassword),
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
