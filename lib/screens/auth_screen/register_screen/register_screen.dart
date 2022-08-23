import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSignInButtonGroup.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Dividers/signInDivider.dart';
import 'package:socale/components/Headers/register_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:get/get.dart';
import 'package:socale/screens/auth_screen/register_screen/verify_email.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/validators.dart';

import '../../../utils/providers/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final Function() back;

  const RegisterScreen({Key? key, required this.back}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  bool isSignUpComplete = false;
  bool isLoading = false;

  updateEmail(value) => setState(() => _email = value);
  updatePassword(value) => setState(() => _password = value);

  getNextPage() async {
    bool isOnboardingDone = await onboardingService.checkIfUserIsOnboarded();
    OnboardingStep currentStep = await onboardingService.getOnboardingStep();

    if (isOnboardingDone) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final user = await Amplify.Auth.getCurrentUser();
      await ref.read(userAsyncController.notifier).setUser(user.userId);
      ref.watch(userAsyncController).when(
            data: (_) {
              Get.offAllNamed('/main');
            },
            error: (err, _) {
              setState(() => isLoading = false);
              final errorSnackBar = SnackBar(
                content: Text(
                  "Something went wrong signing in, please try again.",
                  textAlign: TextAlign.center,
                ),
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
            },
            loading: () {},
          );
      return;
    } else if (currentStep == OnboardingStep.started) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Get.offAllNamed('/email_verification');
      return;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Get.offAllNamed('/onboarding');
      return;
    }
  }

  handleSocialSignIn(AuthProvider oAuth) async {
    // FocusManager.instance.primaryFocus?.unfocus();
    bool isSignedIn = await AuthRepository().signInWithSocialWebUI(oAuth);
    userSignedInHandler(isSignedIn);
  }

  userSignedInHandler(bool isSignedIn) async {
    if (isSignedIn) {
      setState(() => isLoading = false);
      authRepository.startAuthStreamListener();
      Amplify.DataStore.start();
      getNextPage();
    } else {
      print("there was an error signing  up");
      setState(() => isLoading = false);
      final errorSnackBar = SnackBar(
        content: Text(
          "Something went wrong signing up, please try again.",
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  void somethingWrong() {
    setState(() => isLoading = false);
    final errorSnackBar = SnackBar(
      content: Text(
        "Something went wrong signing in, please try again.",
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  emailSignInHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final loadingSnackBar = SnackBar(
      duration: Duration(days: 365),
      content: Row(
        children: [
          Expanded(
            child: Text(
              "Signing up",
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);

    if (!isLoading) {
      setState(() => isLoading = true);
      final form = _formKey.currentState;
      final isValid = form != null ? form.validate() : false;
      if (isValid) {
        form.save();

        try {
          final result = await AuthRepository().signup(_email, _password);
          print(result.nextStep);

          if (result.nextStep.signUpStep == "CONFIRM_SIGN_UP_STEP") {
            verifyEmail();
            return;
          }
        } on UsernameExistsException catch (_) {
          final result = await authRepository.login(_email, _password);
          if (result.nextStep?.signInStep == "CONFIRM_SIGN_UP") {
            verifyEmail();
            return;
          } else {
            userSignedInHandler(result.isSignedIn);
          }
        } on AuthException catch (_) {
          somethingWrong();
        }
      } else {
        return false;
      }
    }
  }

  verifyEmail() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VerifyEmailScreen(
          email: _email,
          password: _password,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        widget.back();
        return false;
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
            child: IconButton(
              onPressed: widget.back,
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RegisterHeader(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            height: 80,
                            child: FormTextField(
                              hint: "Email Address",
                              autoFillHints: {'email', 'email address'},
                              icon: "assets/icons/email_icon.svg",
                              onSave: updateEmail,
                              validator: (value) {
                                return Validators.validateEmail(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            height: 80,
                            child: FormTextField(
                              hint: "Password",
                              autoFillHints: {'password'},
                              icon: "assets/icons/lock_icon.svg",
                              obscureText: true,
                              onSave: updatePassword,
                              validator: Validators.validatePassword,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'By signing up you agree to the Socale Terms of service & Privacy Policy.',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {print('Link clicked')},
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: PrimaryButton(
                            width: size.width,
                            height: 60,
                            colors: [Color(0xFF39EDFF), Color(0xFF0051E1)],
                            text: "Register",
                            onClickEventHandler: emailSignInHandler,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SignInDivider(),
                  SocialSignInButtonGroup(
                    handler: handleSocialSignIn,
                    text: "Sign Up",
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
