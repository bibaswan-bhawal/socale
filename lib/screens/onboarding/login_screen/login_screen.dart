import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSignInButtonGroup.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Dividers/signInDivider.dart';
import 'package:socale/components/Headers/login_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:get/get.dart';
import 'package:socale/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TranslucentBackground(),
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
                  LoginHeader(),
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
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Forgot Password',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
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
                            colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                            text: "Login",
                            onClickEventHandler: () => {validateForm()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SignInDivider(),
                  SocialSignInButtonGroup(
                    handler: AuthRepository().signInWithSocialWebUI,
                    text: "Sign In",
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
    final form = formKey.currentState;
    final isValid = form != null ? form.validate() : false;
    if (isValid) {
      form.save();

      AuthRepository().login(email, password);
    } else {
      return false;
    }
  }

  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
