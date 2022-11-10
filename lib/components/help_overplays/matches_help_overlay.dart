import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/rounded_button.dart';
import 'package:socale/values/colors.dart';

class MatchesHelpOverlay extends StatelessWidget {
  final Function() onDismiss;

  const MatchesHelpOverlay({Key? key, required this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: ColorValues.elementColor.withOpacity(0.7),
        ),
        Center(
          child: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.825,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Color(0xC12C2C2C),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/match_screen_help_animation.gif',
                            width: size.height * 0.25,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome to ',
                                  style: GoogleFonts.poppins(
                                    color: ColorValues.textOnDark,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Socale',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader =
                                          ColorValues.socaleOrangeGradient,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 250,
                            child: Text(
                              "We are glad you joined our community, here are some tips to get started!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: ColorValues.textOnDark,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 25),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 20),
                                    child: Text(
                                      "🤖",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Our machine learning helps you find 5 people to match with.",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorValues.textOnDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 25),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 20),
                                    child: Text(
                                      "👆",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Swipe left or right to view your matches.",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorValues.textOnDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 25),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 20),
                                    child: Text(
                                      "🤩",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "If you find someone interesting try messaging them.",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorValues.textOnDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 25),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 20),
                                    child: Text(
                                      "🙈",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "All matches are anonymous until you both decide to share profiles with each other.",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorValues.textOnDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        child: RoundedButton(
                          height: 60,
                          width: size.width * 0.8,
                          onClickEventHandler: onDismiss,
                          text: 'Start Matching',
                          colors: [
                            Color(0xFFFD6C00),
                            Color(0xFFFFA133),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
