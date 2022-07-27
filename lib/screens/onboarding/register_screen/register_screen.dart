import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSignInButtonGroup.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Dividers/signInDivider.dart';
import 'package:socale/components/Headers/register_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:get/get.dart';
import 'package:socale/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "", password = "";
  bool isSignUpComplete = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TranslucentBackground(
            change: true,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
            child: IconButton(
              onPressed: () => {Get.offAllNamed('/get_started')},
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RegisterHeader(),
                  Form(
                    key: formKey,
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
                              onSave: (value) =>
                                  setState(() => email = value ?? ""),
                              validator: (value) {
                                return Validators.validateEmail(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: SizedBox(
                            height: 80,
                            child: FormTextField(
                              hint: "Password",
                              autoFillHints: {'password'},
                              icon: "assets/icons/lock_icon.svg",
                              obscureText: true,
                              onSave: (value) =>
                                  setState(() => password = value ?? ""),
                              validator: (value) {
                                if (value == null || value.length < 8) {
                                  return "Please enter a password of at least 8 characters.";
                                }
                                return null;
                              },
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
                    handler: AuthRepository().signUpWithSocialWebUI,
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

  validateForm() async {
    print("Registering User");
    final form = formKey.currentState;
    final isValid = form != null ? form.validate() : false;
    if (isValid) {
      print("Form is valid");
      form.save();

      final result = await AuthRepository().signup(email, password);
      if (result) {
        Get.offAllNamed('/email_verification');
      }
    } else {
      return false;
    }
  }
}
