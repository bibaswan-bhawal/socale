import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/TextFields/singleLineTextField/single_line_text_field.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/values/strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          TranslucentBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SingleLineTextField(
                      hint: "Email Address",
                      icon: "assets/icons/email_icon.svg",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SingleLineTextField(
                      hint: "Password",
                      icon: "assets/icons/lock_icon.svg",
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Login",
                      onClickEventHandler: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Google",
                      onClickEventHandler: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Facebook",
                      onClickEventHandler: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      text: "Sign In with Apple",
                      onClickEventHandler: () => {},
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
