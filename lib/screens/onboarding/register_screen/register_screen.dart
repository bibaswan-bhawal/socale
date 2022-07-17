import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/values/strings.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TranslucentBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Text(
                      StringValues.registerHeading,
                      style: GoogleFonts.poppins(
                          fontSize: 38,
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
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: SizedBox(
                      width: 303,
                      child: Text(
                        StringValues.registerDescription,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
