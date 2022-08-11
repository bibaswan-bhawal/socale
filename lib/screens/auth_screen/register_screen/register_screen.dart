import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSignInButtonGroup.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Dividers/signInDivider.dart';
import 'package:socale/components/Headers/register_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:get/get.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  final Function() back;

  const RegisterScreen({Key? key, required this.back}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  bool isSignUpComplete = false;

  updateEmail(value) {
    setState(() => _email = value);
  }

  updatePassword(value) {
    setState(() => _password = value);
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
                            onClickEventHandler: () => {validateForm()},
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

  getNextPage(bool isSignedIn) async {
    if (isSignedIn) {
      bool isOnboardingDone = await onboardingService.checkIfUserIsOnboarded();
      OnboardingStep currentStep = await onboardingService.getOnboardingStep();
      if (!isOnboardingDone) {
        if (currentStep == OnboardingStep.started) {
          Get.offAllNamed('/email_verification');
          return;
        } else {
          Get.offAllNamed('/onboarding');
          return;
        }
      } else {
        Get.offAllNamed('/sign_out');
        return;
      }
    } else {
      print("Error Sign Up");
      return;
    }
  }

  handleSocialSignIn(AuthProvider oAuth) async {
    bool isSignedIn = await AuthRepository().signInWithSocialWebUI(oAuth);
    //getNextPage(isSignedIn);
  }

  validateForm() async {
    final form = _formKey.currentState;
    final isValid = form != null ? form.validate() : false;
    if (isValid) {
      form.save();

      var isSignedIn = await AuthRepository().signup(_email, _password);
      //getNextPage(isSignedIn);
    } else {
      return false;
    }
  }
}
