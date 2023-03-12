import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';

class AcademicInfoHeader extends StatelessWidget {
  const AcademicInfoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Text(
                  'let\'s find you some ',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                  ).createShader(bounds),
                  child: Text(
                    'classmates',
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.058,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/illustration_2.png'),
          ),
        ),
      ],
    );
  }
}
