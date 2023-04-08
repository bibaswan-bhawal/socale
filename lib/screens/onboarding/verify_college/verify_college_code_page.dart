import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/Action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/services/email_verification_service.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class VerifyCollegeCodePage extends ConsumerStatefulWidget {
  final String? email;
  final College? college;

  final Duration timerDuration;

  final Function startTimer;

  const VerifyCollegeCodePage({
    super.key,
    required this.email,
    required this.college,
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

  resendCode() async {
    EmailVerificationService service = ref.read(emailVerificationProvider);

    try {
      await service.sendCode(widget.email!);
      widget.startTimer();
      if (mounted) SystemUI.showSnackBar(message: 'A new code was sent to ${widget.email}', context: context);
    } catch (e) {
      if (kDebugMode) print(e);
      SystemUI.showSnackBar(message: 'There was problem sending your code', context: context);
    }
  }

  bool shouldShowResendButton() {
    if (!(widget.timerDuration.inSeconds < 150)) return true;
    return false;
  }

  saveCode(String? value) => setState(() => code = value);

  bool validateForm() {
    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      if (mounted) SystemUI.showSnackBar(message: 'Invalid code', context: context);
      return false;
    }
  }

  bool isCodeCorrect() {
    final service = ref.read(emailVerificationProvider);
    return service.verifyCode(int.tryParse(code ?? '') ?? -1);
  }

  onSubmit() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (mounted && !validateForm() || !isCodeCorrect()) return setState(() => isLoading = false);

    try {
      final onboardingService = ref.read(onboardingServiceProvider);
      await onboardingService.setCollegeEmail(widget.email!, widget.college);
    } catch (e) {
      if (kDebugMode) print(e);
      SystemUI.showSnackBar(message: 'There was problem verifying your code', context: context);
    }

    if (mounted) setState(() => isLoading = false);
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
                  colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
                ).createShader(bounds),
                child: Text(
                  'student',
                  style: GoogleFonts.poppins(
                      fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
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
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                widget.email!,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.036),
                  color: AppColors.subtitle,
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
                text: 'Resend code',
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
              onPressed: onSubmit,
              linearGradient: AppColors.blackButtonGradient,
            ),
          ]),
        ),
      ],
    );
  }
}
