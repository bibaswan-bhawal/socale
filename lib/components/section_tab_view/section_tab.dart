import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTab extends StatelessWidget {
  final String title;

  const SectionTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 28,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
