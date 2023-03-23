import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/Action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/types/auth/results/auth_flow_result.dart';
import 'package:socale/types/auth/results/auth_verify_email_result.dart';
import 'package:socale/utils/system_ui.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late String _email;
  late String _password;

  final Duration timerDuration = const Duration(seconds: 150);

  Timer? countdownTimer;

  bool isLoading = false;
  bool isSending = false;

  late Duration timeLeft;

  @override
  void initState() {
    super.initState();

    timeLeft = timerDuration;
    String? email = ref.read(authStateProvider).email;
    String? password = ref.read(authStateProvider).password;

    if (email != null && password != null) {
      _email = email;
      _password = password;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  void setCountDown() {
    setState(() {
      final seconds = timeLeft.inSeconds - 1;

      if (seconds < 0) {
        timeLeft = timerDuration;
        countdownTimer!.cancel();
      } else {
        timeLeft = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    countdownTimer?.cancel();
    timeLeft = timerDuration;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    setCountDown();
    setState(() {});
  }

  bool shouldShowResendButton() {
    if (!(timeLeft.inSeconds < 150)) return true;
    return false;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> resendCode() async {
    if (isSending) return;
    setState(() => isSending = true);
    startTimer();
    final result = await ref.read(authServiceProvider).resendVerifyLink(_email);

    setState(() => isSending = false);
    switch (result) {
      case AuthVerifyEmailResult.codeDeliverySuccessful:
        if (mounted) SystemUI.showSnackBar(message: 'A new link as been sent to $_email', context: context);
      case AuthVerifyEmailResult.userAlreadyConfirmed:
        confirmEmail();
      case AuthVerifyEmailResult.limitExceeded:
        if (mounted) {
          SystemUI.showSnackBar(
              message: 'Hold your horses there... You\'ve already requested a link.', context: context);
        }
      case AuthVerifyEmailResult.codeDeliveryFailure:
        if (mounted) {
          SystemUI.showSnackBar(message: 'Something went wrong, try again in a few minutes.', context: context);
        }
      default:
    }
  }

  Future<void> confirmEmail() async {
    if (!isLoading) {
      setState(() => isLoading = true);

      final result = await ref.read(authServiceProvider).signInUser(_email, _password);

      switch (result) {
        case AuthFlowResult.success:
          try {
            if (mounted) await ref.read(authServiceProvider).loginSuccessful(context);
          } catch (e) {
            if (kDebugMode) print(e);
            if (mounted) {
              SystemUI.showSnackBar(message: 'Something went wrong, try again in a few minutes.', context: context);
            }
          }
          return;
        case AuthFlowResult.unverified:
          if (mounted) SystemUI.showSnackBar(message: 'Your email is not verified yet.', context: context);
        case AuthFlowResult.genericError:
          if (mounted) {
            SystemUI.showSnackBar(message: 'Something went wrong, try again in a few minutes.', context: context);
          }
        default:
          if (mounted) SystemUI.showSnackBar(message: 'Something bad happened..., try again', context: context);
          ref.invalidate(authStateProvider);
          ref.read(authStateProvider);
      }

      setState(() => isLoading = false);
    }
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = timeLeft.inMinutes.remainder(60);
    final seconds = strDigits(timeLeft.inSeconds.remainder(60));

    final size = MediaQuery.of(context).size;

    return ScreenScaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/illustrations/illustration_8.png'),
            ),
          ),
          const GradientHeadline(
            headlinePlain: 'Confirm your ',
            headlineColored: 'email',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Column(
              children: [
                Text(
                  'We have sent an email to',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.034),
                    color: ColorValues.textSubtitle,
                  ),
                ),
                Text(
                  _email,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width * 0.036),
                    color: ColorValues.textSubtitle,
                  ),
                ),
                Text(
                  'with a link to confirm your email.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.034),
                    color: ColorValues.textSubtitle,
                  ),
                ),
              ],
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
          ActionGroup(
            actions: [
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
                isLoading: isLoading,
                onPressed: confirmEmail,
                text: 'Continue',
                linearGradient: ColorValues.orangeButtonGradient,
              ),
              LinkButton(
                onPressed: () => Navigator.pop(context),
                text: 'Not the right Email?',
                textStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
