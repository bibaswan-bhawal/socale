import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';

class IntroPage extends StatelessWidget {
  final String illustration;
  final String titleBlack;
  final String titleOrange;
  final String message;

  const IntroPage({
    super.key,
    required this.illustration,
    required this.titleBlack,
    required this.titleOrange,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Center(
            child: Image.asset(illustration),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titleBlack,
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
                        titleOrange,
                        style: GoogleFonts.poppins(
                            fontSize: size.width * 0.058,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.036),
                    color: ColorValues.textSubtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
