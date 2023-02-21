import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form_field.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  String? errorMessage;

  String? email;
  String? password;
  String? confirmPassword;

  saveEmail(String? value) => email = value;

  savePassword(String? value) => password = value;

  saveConfirmPassword(String? value) => confirmPassword = value;

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

  Future<void> onClickRegister() async {
    final form = formState.currentState!;
    setState(() => isLoading = true);

    if (form.validate() && !isLoading) {
      setState(() => errorMessage = null);

      form.save();

      if (password != confirmPassword) {
        showFormError("Passwords don't match");
        return;
      }

      final result = await AuthService.signUpUser(email!, password!);

      switch (result) {
        case AuthFlowResult.success:
          loginSuccessful();
          return;
        case AuthFlowResult.unverified:
          goTo(AuthStep.verifyEmail);
          break;
        case AuthFlowResult.notAuthorized:
          showFormError('Looks like you already have an account. Try signing in.');
          break;
        default:
          showFormError('Something went wrong. Please try again.');
          break;
      }
    } else {
      showFormError('Enter a valid email and confirm passwords match');
    }

    setState(() => isLoading = false);
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
    setState(() {
      errorMessage = message;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScreenScaffold(
      body: Center(
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
                  errorMessage: errorMessage,
                  children: [
                    GroupInputFormField(
                      hintText: 'Email Address',
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                    ),
                    GroupInputFormField(
                      hintText: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
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
                    ),
                    GroupInputFormField(
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
                        fit: BoxFit.contain,
                      ),
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
            Padding(
              padding: EdgeInsets.only(bottom: 40 - MediaQuery.of(context).viewPadding.bottom),
              child: ActionGroup(
                actions: [
                  LinkButton(
                    onPressed: () => goTo(AuthStep.login),
                    text: 'Sign In',
                    prefixText: 'Already have an account?',
                  ),
                  GradientButton(
                    isLoading: isLoading,
                    onPressed: onClickRegister,
                    text: 'Create an Account',
                    linearGradient: ColorValues.purpleButtonGradient,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
