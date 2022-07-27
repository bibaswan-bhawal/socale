import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../values/colors.dart';

class SignInDivider extends StatelessWidget {
  const SignInDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: ColorValues.elementColor,
              indent: 24,
              endIndent: 18,
            ),
          ),
          Text(
            'or',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: ColorValues.elementColor,
              indent: 18,
              endIndent: 24,
            ),
          ),
        ],
      ),
    );
  }
}
