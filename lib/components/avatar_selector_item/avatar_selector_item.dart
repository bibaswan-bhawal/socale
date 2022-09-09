import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';

class AvatarSelectorItem extends StatelessWidget {
  final String image;
  final String sub;

  const AvatarSelectorItem({Key? key, required this.image, required this.sub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image.asset(image),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              sub,
              style: GoogleFonts.poppins(
                color: ColorValues.elementColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
