import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../values/strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: Hero(
            tag: "logo",
            child: SvgPicture.asset(
              'assets/icons/socale_logo_color.svg',
              height: 64,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Text(
            StringValues.loginHeading,
            style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                  color: const Color(0xFF252525),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      color: const Color(0x19252525),
                    ),
                  ],
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
          child: SizedBox(
            width: 303,
            child: Text(
              StringValues.loginDescription,
              style: GoogleFonts.roboto(
                fontSize: 14,
                textStyle: TextStyle(
                  color: const Color(0xE17A7A7A),
                  letterSpacing: 0.1,
                  height: 1.2,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
