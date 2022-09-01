import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/utils/validators.dart';
import 'package:socale/values/styles.dart';

class EmailVerificationPager extends StatefulWidget {
  final PageController pageController;
  final GlobalObjectKey<FormState> formEmailKey, formOptKey;
  final Function(String?) onOtpSaved, onSavedEmail;

  const EmailVerificationPager({
    Key? key,
    required this.pageController,
    required this.formEmailKey,
    required this.formOptKey,
    required this.onOtpSaved,
    required this.onSavedEmail,
  }) : super(key: key);

  @override
  State<EmailVerificationPager> createState() => _EmailVerificationPagerState();
}

class _EmailVerificationPagerState extends State<EmailVerificationPager> {
  final _optFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      onPageChanged: (page) {
        if (page == 1) {
          _optFocusNode.requestFocus();
        }
      },
      physics: NeverScrollableScrollPhysics(),
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
              key: widget.formOptKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                child: PinCodeTextField(
                  focusNode: _optFocusNode,
                  length: 4,
                  useHapticFeedback: true,
                  pinTheme: StyleValues.optPinTheme,
                  hintCharacter: "0",
                  animationType: AnimationType.none,
                  validator: Validators.validateCode,
                  onSaved: widget.onOtpSaved,
                  autovalidateMode: AutovalidateMode.disabled,
                  autoFocus: true,
                  autoDismissKeyboard: true,
                  appContext: context,
                  errorTextSpace: 20,
                  onChanged: (String value) {},
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Resend Code',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.3,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        widget.pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
