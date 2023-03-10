import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Headline extends StatelessWidget {
  final String text;

  const Headline({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SimpleShadow(
      opacity: 0.1,
      offset: const Offset(1, 1),
      sigma: 1,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: size.width * 0.058,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
