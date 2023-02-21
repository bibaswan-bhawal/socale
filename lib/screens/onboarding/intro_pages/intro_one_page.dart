import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';

class IntroOnePage extends StatelessWidget {
  const IntroOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/onboarding_intro/cover_page_1.png'),
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
                'Welcome to ',
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
                  'Socale',
                  style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34, bottom: 74),
          child: Text(
            'Looking for classmates or just trying to\n'
            'keeping up with clubs and events? You can\n'
            'do it all on Socale. The all-in-one college\n'
            'app for students, made by students!',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: (size.width * 0.04),
              color: ColorValues.textSubtitle,
            ),
          ),
        ),
      ],
    );
  }
}
