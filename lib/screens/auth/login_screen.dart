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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> emailFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> passwordFieldState = GlobalKey<FormFieldState>();

  bool formError = false;
  String errorMessage = '';

  String? email;
  String? password;

  bool isLoading = false;

  saveEmail(value) => email = value;
  savePassword(value) => password = value;

  goToSignUp() => ref.read(authStateProvider.notifier).setAuthStep(newStep: AuthStep.register);
  goToForgotPassword() => ref.read(authStateProvider.notifier).setAuthStep(newStep: AuthStep.forgotPassword);

  Future<void> onClickLogin() async {
    final form = formKey.currentState!;

    if (!isLoading) {
      setState(() => isLoading = true);

      if (form.validate()) {
        setState(() => formError = false);
        setState(() => errorMessage = '');

        form.save();

        final result = await AuthService.signInUser(email!, password!);
        setState(() => isLoading = false);

        switch (result) {
          case AuthResult.success:
            ref.read(appStateProvider.notifier).login();
            break;
          case AuthResult.unverified:
            ref.read(authStateProvider.notifier).setAuthStep(newStep: AuthStep.verifyEmail, email: email, password: password);
            break;
          case AuthResult.genericError:
            const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.', textAlign: TextAlign.center));
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
            break;
          case AuthResult.notAuthorized:
            setState(() {
              formError = true;
              errorMessage = 'Incorrect password';
            });

            break;
          case AuthResult.userNotFound:
            const snackBar = SnackBar(content: Text("Sorry, we couldn't find your account. Try signing up", textAlign: TextAlign.center));
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
            break;
        }
      } else {
        setState(() => isLoading = false);
        showError();
      }
    }
  }

  void showError() {
    final emailField = emailFieldState.currentState!;
    final passwordField = passwordFieldState.currentState!;

    if (emailField.errorText != null && passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = 'Enter a valid email and password';
      });
    } else if (emailField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = 'Enter a valid email';
      });
    } else if (passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = 'Enter a valid password';
      });
    }
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
                    isError: formError,
                    errorMessage: errorMessage,
                    children: [
                      GroupInputFormField(
                        key: emailFieldState,
                        hintText: 'Email Address',
                        textInputType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        prefixIcon: SvgPicture.asset('assets/icons/email.svg', color: const Color(0xFF808080), fit: BoxFit.contain),
                        onSaved: saveEmail,
                        validator: Validators.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      GroupInputFormField(
                        key: passwordFieldState,
                        hintText: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: const Color(0xFF808080), fit: BoxFit.contain),
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
                    onPressed: goToSignUp,
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
                    onPressed: goToForgotPassword,
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
