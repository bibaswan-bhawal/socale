import 'package:flutter/foundation.dart';
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
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class VerifyCollegeCodePage extends ConsumerStatefulWidget {
  final String? email;

  final Duration timerDuration;

  final Function startTimer;

  final Function() next;

  const VerifyCollegeCodePage({
    super.key,
    required this.next,
    required this.email,
    required this.timerDuration,
    required this.startTimer,
  });

  @override
  ConsumerState<VerifyCollegeCodePage> createState() => _VerifyCollegeCodePageState();
}

class _VerifyCollegeCodePageState extends ConsumerState<VerifyCollegeCodePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isSending = false;

  String? code;

  bool shouldShowResendButton() {
    if (!(widget.timerDuration.inSeconds < 150)) return true;
    return false;
  }

  saveCode(String? value) => setState(() => code = value);

  validateForm() {
    setState(() => isLoading = true);
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();

      final result = ref.read(emailVerificationProvider).verifyCode(int.parse(code!));

      if (result) {
        changeUserGroup();
      } else {
        setState(() => isLoading = false);
        if (mounted) SystemUI.showSnackBar(message: 'Incorrect Code, try again.', context: context);
      }
    }
  }

  resendCode() async {
    EmailVerificationService service = ref.read(emailVerificationProvider);
    final response = await service.sendCode(widget.email!);
    if (response) {
      widget.startTimer();
      if (mounted) SystemUI.showSnackBar(message: 'Sent a new code to ${widget.email}', context: context);
    } else {
      if (mounted) SystemUI.showSnackBar(message: 'There was problem sending your code', context: context);
    }
  }

  changeUserGroup() async {
    final onboardingService = ref.read(onboardingServiceProvider);

    try {
      final response = await onboardingService.addUserToCollege();

      if (response) {
        setState(() => isLoading = false);
        widget.next();
      } else {
        throw Exception('unable to add user to group');
      }
    } catch (e) {
      if (kDebugMode) print(e);
      setState(() => isLoading = false);
      SystemUI.showSnackBar(message: 'There was an error, try again.', context: context);
    }
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = widget.timerDuration.inMinutes.remainder(60);
    final seconds = strDigits(widget.timerDuration.inSeconds.remainder(60));

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
                  style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
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
        if (!shouldShowResendButton())
          SizedBox(
            height: 48,
            child: Center(
              child: Text(
                'Resend Code in $minutes:$seconds',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ActionGroup(actions: [
            if (shouldShowResendButton())
              LinkButton(
                onPressed: resendCode,
                text: 'Resend link',
                isLoading: isSending,
                textStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            GradientButton(
              text: 'Verify',
              isLoading: isLoading,
              onPressed: validateForm,
              linearGradient: ColorValues.blackButtonGradient,
            ),
          ]),
        ),
      ],
    );
  }
}
