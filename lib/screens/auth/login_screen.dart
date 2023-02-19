import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/text_button.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form_field.dart';
import 'package:socale/components/utils/keyboard_safe_area.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? errorMessage;

  bool isLoading = false;

  String? email;
  String? password;

  saveEmail(String? value) => email = value;

  savePassword(String? value) => password = value;

  goTo(AuthStep step) {
    final authState = ref.read(authStateProvider.notifier);

    switch (step) {
      case AuthStep.verifyEmail:
        authState.setAuthStep(newStep: step, email: email, password: password);
        break;
      default:
        authState.setAuthStep(newStep: step);
        break;
    }
  }

  onClickLogin() async {
    final form = formKey.currentState!;

    if (!isLoading) {
      setState(() => isLoading = true);

      if (form.validate()) {
        setState(() => errorMessage = null);

        form.save();

        final result = await AuthService.signInUser(email!, password!);

        switch (result) {
          case AuthFlowResult.success:
            loginSuccessful();
            return;
          case AuthFlowResult.unverified:
            goTo(AuthStep.verifyEmail); // Go to verify email screen
            break;
          case AuthFlowResult.genericError:
            showSnackBar('Something went wrong try again in a few minutes.');
            break;
          case AuthFlowResult.notAuthorized:
            showFormError('Incorrect password');
            break;
          case AuthFlowResult.userNotFound:
            showSnackBar("Sorry, we couldn't find your account. Try signing up");
            break;
        }
      } else {
        showFormError('Enter a valid email and password');
      }

      setState(() => isLoading = false);
    }
  }

  loginSuccessful() async {
    final appState = ref.read(appStateProvider.notifier);
    final currentUser = ref.read(currentUserProvider.notifier);

    final tokens = await AuthService.getAuthTokens();

    currentUser.setTokens(
      idToken: tokens.$1,
      accessToken: tokens.$2,
      refreshToken: tokens.$3,
    );

    appState.login();
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message, textAlign: TextAlign.center));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showFormError(String message) {
    setState(() => errorMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: KeyboardSafeArea(
        child: Center(
          child: Column(
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
                padding: EdgeInsets.only(top: size.height * 0.08 - 54),
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
                  child: GroupInputForm(
                    errorMessage: errorMessage,
                    children: [
                      GroupInputFormField(
                        hintText: 'Email Address',
                        textInputType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/email.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF808080),
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                        onSaved: saveEmail,
                        validator: Validators.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      GroupInputFormField(
                        hintText: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/lock.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF808080),
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                        isObscured: true,
                        onSaved: savePassword,
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
                    onPressed: onClickLogin,
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
        ),
      ),
    );
  }
}
