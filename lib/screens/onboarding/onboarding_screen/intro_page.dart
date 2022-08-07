import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:socale/values/colors.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Image.asset(
                'assets/images/onboarding_illustration_3.png',
                height: size.height / 2.2,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to ',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Socale',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = ColorValues.socaleOrange,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: SizedBox(
                width: 300,
                child: Text(
                  'The first social network to use the power of Machine Learning to find people you will vibe with on campus.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    textStyle: TextStyle(
                      color: const Color(0xFF7A7A7A),
                      height: 1.4,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
