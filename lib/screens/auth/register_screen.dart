import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text_fields/group_input_fields/grouped_input_field.dart';
import 'package:socale/components/text_fields/group_input_fields/grouped_input_form.dart';
import 'package:socale/resources/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LightOnboardingBackground(),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 60),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.translucent,
              child: SvgPicture.asset('assets/icons/back.svg'),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Hero(
                      tag: "auth_logo",
                      child: SvgPicture.asset(
                        'assets/logo/color_logo.svg',
                        width: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Hello There",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Sign up to start matching",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 30),
                    child: GroupedInputForm(
                      children: [
                        GroupedInputField(
                          hintText: "Email Address",
                          textInputType: TextInputType.emailAddress,
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/email.svg',
                            color: Color(0xFF808080),
                            width: 16,
                          ),
                        ),
                        GroupedInputField(
                          hintText: "Password",
                          textInputType: TextInputType.visiblePassword,
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/lock.svg',
                            color: Color(0xFF808080),
                            width: 16,
                          ),
                          isObscured: true,
                        ),
                        GroupedInputField(
                          hintText: "Confirm Password",
                          textInputType: TextInputType.visiblePassword,
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/lock.svg',
                            color: Color(0xFF808080),
                            width: 16,
                          ),
                          isObscured: true,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "By signing up you agree to the Socale",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: Colors.black,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms of service",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: " & "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 40 - MediaQuery.of(context).padding.bottom),
                    child: GradientButton(
                      width: size.width - 60,
                      height: 48,
                      linearGradient: ColorValues.purpleButtonGradient,
                      buttonContent: Text(
                        "Create an Account",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onClickEvent: () => {},
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
