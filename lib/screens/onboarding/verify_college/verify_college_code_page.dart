import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/Action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/services/email_verification_service.dart';
import 'package:socale/utils/validators.dart';

class VerifyCollegeCodePage extends ConsumerStatefulWidget {
  final String? email;

  final Function() next;

  const VerifyCollegeCodePage({super.key, required this.next, required this.email});

  @override
  ConsumerState<VerifyCollegeCodePage> createState() => _VerifyCollegeCodePageState();
}

class _VerifyCollegeCodePageState extends ConsumerState<VerifyCollegeCodePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? code;

  saveCode(String? value) => setState(() => code = value);

  validateForm() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();

      EmailVerificationService service = ref.read(emailVerificationProvider);

      final result = await service.verifyCode(int.parse(code!));

      if (result) {
        widget.next();
      } else {
        const snackBar = SnackBar(content: Text('Incorrect Code, try again.', textAlign: TextAlign.center));
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  sendCode() async {
    EmailVerificationService service = ref.read(emailVerificationProvider);
    final response = await service.sendCode(widget.email!);
    if (response) {
      showSnackBar('Sent a new code to ${widget.email}');
    } else {
      showSnackBar('There was problem sending your code.');
    }
  }

  showSnackBar(String message) {
    if (mounted) ScaffoldMessenger.of(context).clearSnackBars();
    if (mounted) ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      duration: const Duration(seconds: 1),
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SimpleShadow(
          opacity: 0.1,
          offset: const Offset(1, 1),
          sigma: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify you're a ",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: size.width * 0.058,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                ).createShader(bounds),
                child: Text(
                  'student',
                  style: GoogleFonts.poppins(
                      fontSize: size.width * 0.058,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              Text(
                'Enter the code that was sent to',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: (size.width * 0.034),
                  color: ColorValues.textSubtitle,
                ),
              ),
              Text(
                widget.email ?? '',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.036),
                  color: ColorValues.textSubtitle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
            child: Form(
              key: formKey,
              child: PinCodeTextField(
                length: 6,
                appContext: context,
                useHapticFeedback: true,
                pinTheme: Themes.optPinTheme,
                cursorColor: Colors.black,
                hintCharacter: '0',
                autovalidateMode: AutovalidateMode.disabled,
                keyboardType: TextInputType.number,
                autoFocus: true,
                autoDismissKeyboard: true,
                errorTextSpace: 20,
                onSaved: saveCode,
                onChanged: (value) {},
                validator: Validators.validateCode,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ActionGroup(actions: [
            LinkButton(
              onPressed: sendCode,
              text: 'resend code',
            ),
            GradientButton(
              text: 'Verify',
              onPressed: validateForm,
              linearGradient: ColorValues.blackButtonGradient,
            ),
          ]),
        ),
      ],
    );
  }
}
