import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';

class GradientHeadline extends StatelessWidget {
  final String headlinePlain;
  final String headlineColored;
  final bool newLine;

  const GradientHeadline({
    super.key,
    required this.headlinePlain,
    required this.headlineColored,
    this.newLine = false,
  });

  List<Widget> buildList(Size size) => [
        Text(
          '$headlinePlain ',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: size.width * 0.054,
            fontWeight: FontWeight.bold,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
          ).createShader(bounds),
          child: Text(
            headlineColored,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.054,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SimpleShadow(
      opacity: 0.1,
      offset: const Offset(1, 1),
      sigma: 1,
      child: newLine
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: buildList(size))
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: buildList(size)),
    );
  }
}
