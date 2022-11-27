import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/utils/routes.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  void confirmEmail(String email) {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as VerifyScreenArguments;

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
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Confirm your ",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: size.width * 0.058,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Email',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.058,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = ColorValues.orangeButtonGradient.createShader(Rect.fromLTRB(0.0, 0.0, 2.0, 2.0)),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
                        args.email,
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
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: GradientButton(
                    width: size.width - 60,
                    height: 48,
                    linearGradient: ColorValues.orangeButtonGradient,
                    buttonContent: Text(
                      "Continue",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onClickEvent: () => confirmEmail(args.email),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Not the right email?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.75),
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
