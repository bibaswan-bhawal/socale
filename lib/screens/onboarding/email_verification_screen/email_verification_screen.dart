import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import '../../../components/Buttons/primary_button.dart';
import '../../../components/translucent_background/translucent_background.dart';
import '../../../utils/validators.dart';
import '../../../values/strings.dart';
import '../../../values/styles.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  String code = "", email = "";
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    validateForm() async {
      print("Email Verification");
      final form = formKey.currentState;
      final isValid = form != null ? form.validate() : false;
      if (isValid) {
        form.save();
        // TODO: Email is valid send code
        setState(() => isVisible = false); // Show code input field
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TranslucentBackground(),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/onboarding_illustration_2.png',
                      height: size.height / 2.2,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Text(
                        StringValues.emailVerificationHeading,
                        style: StyleValues.heading1Style,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: SizedBox(
                        width: 280,
                        child: Text(
                          StringValues.emailVerificationDescription,
                          style: StyleValues.description1Style,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          if (!isVisible)
                            Padding(
                              padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                              child: PinCodeTextField(
                                length: 4,
                                obscureText: false,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 40,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                onCompleted: (value) {
                                  print("Completed code is: " + code);
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    code = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  return true;
                                },
                                appContext: context,
                              ),
                            ),
                          if (isVisible)
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: PrimaryButton(
                              width: size.width,
                              height: 60,
                              colors: [Color(0xFF2F3136), Color(0xFF2F3136)],
                              text: "Verify",
                              onClickEventHandler: () => {validateForm()},
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isVisible)
                      Padding(
                        padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Resend Code',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.3),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => {setState(() => isVisible = true)},
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
