// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/chips/category_chip_select/category_chip_select_input.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/options/hobbies.dart';
import 'package:socale/values/colors.dart';

class HobbiesPage extends StatefulWidget {
  const HobbiesPage({Key? key}) : super(key: key);

  @override
  State<HobbiesPage> createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<HobbiesPage> {
  List<String> hobbies = [];

  onChanged(List<String> values) {
    setState(() => hobbies = values);
    onboardingService.setLeisureInterests(values);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 90, left: 30),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'What are your ',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Hobbies?',
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
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "In my free time I like to...",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color(0xFF606060),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: CategoryChipSelectInput(
                  onChange: onChanged,
                  map: hobbiesOptionsList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
