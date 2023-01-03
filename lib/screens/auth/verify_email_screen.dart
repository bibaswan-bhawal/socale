import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_result.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email = "";
  final String password = "";

  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool isLoading = false;

  void resendCode() async {
    final result = await AuthService.resendVerifyLink(widget.email);
    if (result) {
      const snackBar = SnackBar(content: Text("A new link as been sent to your email", textAlign: TextAlign.center));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(content: Text("There was an error, try again later", textAlign: TextAlign.center));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void confirmEmail() async {
    if (!isLoading) {
      setState(() => isLoading = true);

      final result = await AuthService.signInUser(widget.email, widget.password);
      setState(() => isLoading = false);

      switch (result) {
        case AuthResult.success:
          ref.read(appStateProvider.notifier).login();
          break;
        case AuthResult.unverified:
          const snackBar = SnackBar(content: Text("Your email is not verified yet."));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case AuthResult.genericError:
          const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.'));
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        default:
          ref.read(authStateProvider.notifier).setAuthAction(AuthAction.noAction);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const LightOnboardingBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset('assets/verify_email/cover_illustration.png'),
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
                        "Confirm your ",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: size.width * 0.058,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                        ).createShader(bounds),
                        child: Text(
                          "email",
                          style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: size.width * 0.10, right: size.width * 0.10, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "We have sent an email to",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: (size.width * 0.04),
                          color: ColorValues.textSubtitle,
                        ),
                      ),
                      Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: (size.width * 0.04),
                          color: ColorValues.textSubtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "with a link to confirm your email.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: (size.width * 0.04),
                          color: ColorValues.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 20),
                  child: GestureDetector(
                    onTap: resendCode,
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Resend link",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ),
                ),
                GradientButton(
                  isLoading: isLoading,
                  linearGradient: ColorValues.orangeButtonGradient,
                  buttonContent: "Continue",
                  onClickEvent: confirmEmail,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 30),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Not the right email?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF4D4D4D).withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
