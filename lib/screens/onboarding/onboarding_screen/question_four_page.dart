// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';

class QuestionFourPage extends StatefulWidget {
  final Function(double, int) onChange;
  const QuestionFourPage({Key? key, required this.onChange}) : super(key: key);

  @override
  State<QuestionFourPage> createState() => _QuestionFourPageState();
}

class _QuestionFourPageState extends State<QuestionFourPage> {
  double _currentSliderValue = 20;

  onChanged(value) {
    setState(() => _currentSliderValue = value);
    widget.onChange(value, 3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 100, left: 30, right: 30),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Let's get to know you ",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'better!',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = ColorValues.socaleOrangeGradient,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Text(
                  "How much does this following statement describe you?",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF606060),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100, left: 40, right: 40),
                child: Text(
                  "You usually follow your head more than your heart when making decisions.",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 30, right: 30),
              child: Slider(
                value: _currentSliderValue,
                max: 100,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: onChanged,
              ),
            )
          ],
        ),
      ),
    );
  }
}
