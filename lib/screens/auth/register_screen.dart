import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form_field.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/animated_navigators.dart';
import 'package:socale/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<FormFieldState> emailFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> passwordFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> confirmPasswordFieldState = GlobalKey<FormFieldState>();

  bool formError = false;
  bool isLoading = false;

  String errorMessage = "";

  String? email;
  String? password;
  String? confirmPassword;

  saveEmail(value) => email = value;
  savePassword(value) => password = value;
  saveConfirmPassword(value) => confirmPassword = value;

  Future<void> onClickRegister() async {
    final form = formState.currentState!;
    if (form.validate() && !isLoading) {
      setState(() => isLoading = true);

      setState(() => formError = false);
      setState(() => errorMessage = "");
      form.save();

      if (password != confirmPassword) {
        setState(() {
          formError = true;
          errorMessage = "Password don't match";
        });

        setState(() => isLoading = false);
        return;
      }

      print("Register Account with email:$email and password:$password");

      await AuthService.signUpUser(email!, password!);

      setState(() => isLoading = false);
    } else {
      showError();
    }
  }

  void showError() {
    final emailField = emailFieldState.currentState!;
    final passwordField = passwordFieldState.currentState!;
    final confirmPasswordField = confirmPasswordFieldState.currentState!;

    if (emailField.errorText != null && passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Enter a valid email and password";
      });
    }
    if (emailField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Enter a valid email";
      });
    } else if (passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Enter a valid 8 character password";
      });
    } else if (confirmPasswordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Password don't match";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LightOnboardingBackground(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 60),
              child: SvgPicture.asset('assets/icons/back.svg'),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 80),
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
                      "Hello There",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Sign up to start matching",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 30),
                    child: Form(
                      key: formState,
                      child: GroupInputForm(
                        isError: formError,
                        errorMessage: errorMessage,
                        children: [
                          GroupInputFormField(
                            key: emailFieldState,
                            hintText: "Email Address",
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: SvgPicture.asset('assets/icons/email.svg',
                                color: Color(0xFF808080), width: 16),
                            onSaved: saveEmail,
                            validator: Validators.validateEmail,
                          ),
                          GroupInputFormField(
                            key: passwordFieldState,
                            hintText: "Password",
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            prefixIcon: SvgPicture.asset('assets/icons/lock.svg',
                                color: Color(0xFF808080), width: 16),
                            isObscured: true,
                            onSaved: savePassword,
                            validator: Validators.validatePassword,
                          ),
                          GroupInputFormField(
                            key: confirmPasswordFieldState,
                            hintText: "Confirm Password",
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            prefixIcon: SvgPicture.asset('assets/icons/lock.svg',
                                color: Color(0xFF808080), width: 16),
                            isObscured: true,
                            onSaved: saveConfirmPassword,
                            validator: Validators.validatePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "By signing up you agree to the Socale",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: Colors.black,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms of service",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchUrl(
                                    Uri.parse('http://socale.co/tos'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                            ),
                            TextSpan(text: " & "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchUrl(
                                    Uri.parse('http://socale.co/privacypolicy'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                AnimatedNavigators.replaceGoToWithSlide(context, LoginScreen());
                              }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 40 - MediaQuery.of(context).padding.bottom),
                    child: GradientButton(
                      width: size.width - 60,
                      height: 48,
                      linearGradient: ColorValues.purpleButtonGradient,
                      buttonContent: Text(
                        "Create an Account",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onClickEvent: onClickRegister,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
