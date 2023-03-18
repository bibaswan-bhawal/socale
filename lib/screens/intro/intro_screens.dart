import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/resources/colors.dart';

class IntroScreen {
  static Widget first() => const _IntroScreen(
        titleBlack: 'Welcome to',
        titleOrange: 'Socale',
        message: 'Looking for classmates or just trying to\n'
            'keep up with clubs and events? You can\n'
            'do it all on Socale. The all-in-one college\n'
            'app for students, made by students!',
        illustration: 'assets/illustrations/illustration_5.png',
      );

  static Widget second() => const _IntroScreen(
        titleBlack: 'Made for',
        titleOrange: 'you',
        message: 'Every day we will recommend 5 people who\n'
            'we think you will find interesting based on\n'
            'your profile. The more you use the app, the\n'
            'better your recommendations will be.',
        illustration: 'assets/illustrations/illustration_3.png',
      );

  static Widget third() => const _IntroScreen(
        titleBlack: 'One more',
        titleOrange: 'thing...',
        message: 'The best part about Socale is that you are \n'
            'completely anonymous. You have the ability\n'
            'to choose who can see your profile and we \n'
            'will never share your personal information\n'
            'with anyone without your permission.',
        illustration: 'assets/illustrations/illustration_4.png',
      );
}

class _IntroScreen extends StatelessWidget {
  final String illustration;
  final String titleBlack;
  final String titleOrange;
  final String message;

  const _IntroScreen({
    required this.illustration,
    required this.titleBlack,
    required this.titleOrange,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 4,
          fit: FlexFit.loose,
          child: Image.asset(illustration, width: size.width, height: size.width),
        ),
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GradientHeadline(headlinePlain: titleBlack, headlineColored: titleOrange),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.034),
                    color: ColorValues.textSubtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
