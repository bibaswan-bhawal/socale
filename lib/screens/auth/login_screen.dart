import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form_field.dart';
import 'package:socale/components/utils/keyboard_safe_area.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/forgot_password_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/state_machines/state_values/auth_state_values.dart';
import 'package:socale/utils/animated_navigators.dart';
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
  String errorMessage = "";

  String? email;
  String? password;

  bool isLoading = false;

  saveEmail(value) => email = value;
  savePassword(value) => password = value;

  Future<void> onClickLogin() async {
    final form = formKey.currentState!;

    if (!isLoading) {
      setState(() => isLoading = true);

      if (form.validate()) {
        setState(() => formError = false);
        setState(() => errorMessage = "");

        form.save();

        final result = await AuthService.signInUser(email!, password!);
        setState(() => isLoading = false);

        if (result == AuthStateValue.unverified) {
          if (mounted) AnimatedNavigators.goToWithSlide(context, VerifyEmailScreen(email: email!, password: password!));
          return;
        }

        if (result == AuthStateValue.error) {
          const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.'));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return;
        }

        if (result == AuthStateValue.notAuthorized) {
          setState(() {
            formError = true;
            errorMessage = "Incorrect password";
          });

          return;
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
        errorMessage = "Enter a valid email and password";
      });
    } else if (emailField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Enter a valid email";
      });
    } else if (passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Enter a valid password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const LightOnboardingBackground(),
          KeyboardSafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.08),
                    child: Hero(
                      tag: "auth_logo",
                      child: SvgPicture.asset(
                        'assets/logo/color_logo.svg',
                        width: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Welcome Back",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Login to start matching",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 30),
                    child: Form(
                      key: formKey,
                      child: GroupInputForm(
                        isError: formError,
                        errorMessage: errorMessage,
                        children: [
                          GroupInputFormField(
                            key: emailFieldState,
                            hintText: "Email Address",
                            textInputType: TextInputType.emailAddress,
                            autofillHints: [AutofillHints.email],
                            prefixIcon: SvgPicture.asset('assets/icons/email.svg', color: Color(0xFF808080), width: 16),
                            onSaved: saveEmail,
                            validator: Validators.validateEmail,
                            textInputAction: TextInputAction.next,
                          ),
                          GroupInputFormField(
                            key: passwordFieldState,
                            hintText: "Password",
                            textInputType: TextInputType.visiblePassword,
                            autofillHints: [AutofillHints.password],
                            prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: Color(0xFF808080), width: 16),
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              AnimatedNavigators.replaceGoToWithSlide(context, RegisterScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 30),
                    child: Hero(
                      tag: "login_button",
                      child: GradientButton(
                        isLoading: isLoading,
                        width: size.width - 60,
                        height: 48,
                        linearGradient: ColorValues.orangeButtonGradient,
                        buttonContent: Text(
                          "Sign In",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onClickEvent: onClickLogin,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: GestureDetector(
                      onTap: () {
                        AnimatedNavigators.goToWithSlide(context, ForgotPasswordScreen());
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 60),
              child: SvgPicture.asset('assets/icons/back.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
