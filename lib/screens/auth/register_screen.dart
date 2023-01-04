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
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<FormFieldState> emailFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> passwordFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> confirmPasswordFieldState = GlobalKey<FormFieldState>();

  bool formError = false;
  bool isLoading = false;

  String errorMessage = '';

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
      setState(() => errorMessage = '');
      form.save();

      if (password != confirmPassword) {
        setState(() {
          formError = true;
          errorMessage = "Passwords don't match";
        });

        setState(() => isLoading = false);
        return;
      }

      final result = await AuthService.signUpUser(email!, password!);
      setState(() => isLoading = false);

      switch (result) {
        case AuthResult.success:
          ref.read(appStateProvider.notifier).login();
          break;
        case AuthResult.unverified:
          ref.read(authStateProvider.notifier).verifyEmail(true);
          break;
        case AuthResult.genericError:
          const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.'));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case AuthResult.notAuthorized:
          setState(() {
            formError = true;
            errorMessage = 'Incorrect password';
          });

          break;
        case AuthResult.userNotFound:
          const snackBar = SnackBar(content: Text("Sorry, we couldn't find your account. Try signing up"));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    } else {
      setState(() => isLoading = false);
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
        errorMessage = 'Enter a valid email and password';
      });
    }
    if (emailField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = 'Enter a valid email';
      });
    } else if (passwordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = 'Password must be at least 8 characters';
      });
    } else if (confirmPasswordField.errorText != null) {
      setState(() {
        formError = true;
        errorMessage = "Passwords don't match";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          KeyboardSafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.08),
                    child: Hero(
                      tag: 'auth_logo',
                      child: SvgPicture.asset(
                        'assets/logo/color_logo.svg',
                        width: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Hello There',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'Sign up to start matching',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 48, left: 30, right: 30),
                    child: Form(
                      key: formState,
                      child: GroupInputForm(
                        isError: formError,
                        errorMessage: errorMessage,
                        children: [
                          GroupInputFormField(
                            key: emailFieldState,
                            hintText: 'Email Address',
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            prefixIcon: SvgPicture.asset('assets/icons/email.svg', color: const Color(0xFF808080), width: 16),
                            onSaved: saveEmail,
                            validator: Validators.validateEmail,
                          ),
                          GroupInputFormField(
                            key: passwordFieldState,
                            hintText: 'Password',
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: const Color(0xFF808080), width: 16),
                            isObscured: true,
                            onSaved: savePassword,
                            validator: Validators.validatePassword,
                          ),
                          GroupInputFormField(
                            key: confirmPasswordFieldState,
                            hintText: 'Confirm Password',
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: const Color(0xFF808080), width: 16),
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
                        'By signing up you agree to the Socale',
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
                              text: 'Terms of service',
                              style: const TextStyle(
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
                            const TextSpan(text: ' & '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
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
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => ref.read(authStateProvider.notifier).setAuthAction(AuthAction.signIn),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20, left: 36, right: 36),
                    child: GradientButton(
                      isLoading: isLoading,
                      linearGradient: ColorValues.purpleButtonGradient,
                      buttonContent: 'Create an Account',
                      onClickEvent: onClickRegister,
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
