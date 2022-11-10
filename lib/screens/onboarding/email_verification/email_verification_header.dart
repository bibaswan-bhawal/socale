import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/strings.dart';

class EmailVerificationHeader extends StatelessWidget {
  const EmailVerificationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Image.asset(
              'assets/images/onboarding_illustration_2.png',
            ),
          ),
        ),
        Text(
          StringValues.emailVerificationHeading,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.bold,
            textStyle: TextStyle(
              color: ColorValues.textHeading,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1, 2),
                  blurRadius: 3,
                  color: ColorValues.textHeadingShadow,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: SizedBox(
            width: 280,
            child: Text(
              StringValues.emailVerificationDescription,
              style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                textStyle: TextStyle(
                  color: ColorValues.textDescription,
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
