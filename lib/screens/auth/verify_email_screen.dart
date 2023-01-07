import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/Action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/text_button.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late String _email;
  late String _password;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    String? email = ref.read(authStateProvider).email;
    String? password = ref.read(authStateProvider).password;

    if (email != null && password != null) {
      _email = email;
      _password = password;
    }
  }

  void resendCode() async {
    final result = await AuthService.resendVerifyLink(_email);
    if (result) {
      const snackBar = SnackBar(content: Text('A new link as been sent to your email', textAlign: TextAlign.center));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(content: Text('There was an error, try again later', textAlign: TextAlign.center));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void confirmEmail() async {
    if (!isLoading) {
      setState(() => isLoading = true);

      final result = await AuthService.signInUser(_email, _password);
      setState(() => isLoading = false);
      print(result);

      switch (result) {
        case AuthResult.success:
          ref.read(appStateProvider.notifier).login();
          break;
        case AuthResult.unverified:
          const snackBar = SnackBar(content: Text('Your email is not verified yet.', textAlign: TextAlign.center));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case AuthResult.genericError:
          const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.', textAlign: TextAlign.center));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        default:
          ref.invalidate(authStateProvider);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset('assets/illustrations/verify_email/cover_illustration.png'),
              ),
            ),
            SimpleShadow(
              opacity: 0.1,
              offset: const Offset(1, 1),
              sigma: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm your ',
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
                      'email',
                      style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    'We have sent an email to',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.04),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.04),
                      color: ColorValues.textSubtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'with a link to confirm your email.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.04),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            ActionGroup(
              actions: [
                LinkButton(
                  onPressed: resendCode,
                  text: 'Resend link',
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
      ),
    );
  }
}
