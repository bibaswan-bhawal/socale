import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/validators.dart';
import 'package:socale/values/colors.dart';

class EmailVerificationPager extends StatefulWidget {
  final GlobalObjectKey<FormState> formEmailKey, formCodeKey;
  final PageController pageController;
  final Function(String?) onSavedCode, onSavedEmail;

  const EmailVerificationPager({
    Key? key,
    required this.formEmailKey,
    required this.formCodeKey,
    required this.pageController,
    required this.onSavedCode,
    required this.onSavedEmail,
  }) : super(key: key);

  @override
  State<EmailVerificationPager> createState() => _EmailVerificationPagerState();
}

class _EmailVerificationPagerState extends State<EmailVerificationPager> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: widget.pageController,
      children: [
        Form(
          key: widget.formEmailKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SizedBox(
              child: FormTextField(
                hint: "Email Address",
                autoFillHints: {'email', 'email address'},
                icon: "assets/icons/email_icon.svg",
                onSave: widget.onSavedEmail,
                validator: Validators.validateUCSDEmail,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Form(
              key: widget.formCodeKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                child: PinCodeTextField(
                  length: 4,
                  useHapticFeedback: true,
                  pinTheme: getPinTheme(),
                  hintCharacter: "0",
                  animationType: AnimationType.none,
                  onCompleted: onComplete,
                  onChanged: onChange,
                  validator: Validators.validateCode,
                  onSaved: widget.onSavedCode,
                  autovalidateMode: AutovalidateMode.disabled,
                  autoFocus: true,
                  autoDismissKeyboard: true,
                  appContext: context,
                  beforeTextPaste: beforeTextPaste,
                  errorTextSpace: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
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
                        ..onTap = () {
                          widget.pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  onComplete(value) {}
  onChange(value) {}

  bool beforeTextPaste(value) {
    return int.tryParse(value!) != null ? true : false;
  }

  getPinTheme() {
    return PinTheme(
      shape: PinCodeFieldShape.underline,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 40,
      fieldWidth: 40,
      activeColor: Colors.black,
      selectedColor: ColorValues.socaleOrange,
      inactiveColor: Colors.black,
    );
  }
}
