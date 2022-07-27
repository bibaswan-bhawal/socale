import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/strings.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({Key? key}) : super(key: key);

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
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hello There',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    textStyle: TextStyle(
                      color: const Color(0xFF252525),
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: const Color(0x19252525),
                        ),
                      ],
                    ),
                  ),
                ),
                TextSpan(
                  text: '...',
                  style: GoogleFonts.mochiyPopOne(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    textStyle: TextStyle(
                      color: const Color(0xFF252525),
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: const Color(0x19252525),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: SizedBox(
            width: 303,
            child: Text(
              StringValues.registerDescription,
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
