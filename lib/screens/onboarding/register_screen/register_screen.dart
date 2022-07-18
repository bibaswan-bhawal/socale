import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/values/strings.dart';

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
          TranslucentBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 64,
                    child: Hero(
                      tag: "logo",
                      child: SvgPicture.asset(
                        'assets/icons/socale_logo_color.svg',
                        height: 64,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: Text(
                      StringValues.registerHeading,
                      style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          textStyle: TextStyle(
                            color: const Color(0xFF252525),
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 5,
                                color: const Color(0x19252525),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                    child: SizedBox(
                      width: 303,
                      child: Text(
                        StringValues.registerDescription,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          textStyle: TextStyle(
                            color: const Color(0xE17A7A7A),
                            letterSpacing: 0.1,
                            height: 1.2,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: FormTextField(
                            hint: "Email Address",
                            icon: "assets/icons/email_icon.svg",
                            onSave: (value) =>
                                setState(() => email = value ?? ""),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: FormTextField(
                            hint: "Password",
                            icon: "assets/icons/lock_icon.svg",
                            obscureText: true,
                            onSave: (value) =>
                                setState(() => password = value ?? ""),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: PrimaryButton(
                            width: size.width,
                            height: 60,
                            text: "Register",
                            onClickEventHandler: () => {validateForm()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Google",
                      onClickEventHandler: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Facebook",
                      onClickEventHandler: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Apple",
                      onClickEventHandler: () => {},
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

  validateForm() async {
    print("Registering User");
    final form = formKey.currentState;
    final isValid = form != null ? form.validate() : false;
    if (isValid) {
      print("Form is valid");
      form.save();

      final result = AuthRepository().signup(email, password);
      print(result);
    } else {
      return false;
    }
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return "Enter valid Email";
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "Enter Valid Email";
    } else {
      return null;
    }
  }
}
