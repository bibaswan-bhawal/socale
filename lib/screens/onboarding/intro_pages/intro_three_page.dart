import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';

class IntroThreePage extends StatelessWidget {
  const IntroThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/onboarding_intro/cover_page_3.png'),
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
                'One more ',
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
                  'Thing...',
                  style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34, bottom: 74),
          child: Text(
            'The best part about Socale is that you are \n'
            'completely anonymous. You have the ability\n'
            'to choose who can see your profile and we \n'
            'will never share your personal information\n'
            'with anyone without your permission.',
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
