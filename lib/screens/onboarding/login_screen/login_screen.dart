import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSigninButtonGroup.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Headers/login_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';

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
            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: FormTextField(
                            hint: "Email Address",
                            icon: "assets/icons/email_icon.svg",
                            onSave: (value) =>
                                setState(() => email = value ?? ""),
                            validator: (value) {
                              return validateEmail(value);
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
                            text: "Login",
                            onClickEventHandler: () => {validateForm()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SocialSignInButtonGroup(),
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
