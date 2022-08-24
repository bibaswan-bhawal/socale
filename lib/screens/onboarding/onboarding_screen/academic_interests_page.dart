// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/chips/category_chip_select/category_chip_select_input.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/options/academic_interests.dart';
import 'package:socale/values/colors.dart';

class AcademicInterestsPage extends StatefulWidget {
  const AcademicInterestsPage({Key? key}) : super(key: key);

  @override
  State<AcademicInterestsPage> createState() => _AcademicInterestsPageState();
}

class _AcademicInterestsPageState extends State<AcademicInterestsPage> {
  List<String> academicInterests = [];

  onChanged(List<String> values) {
    setState(() => academicInterests = values);
    print('tot');
    onboardingService.setAcademicInterests(values);
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
                padding: EdgeInsets.only(top: 70, left: 30, right: 5),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'what are your academic ',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Interests?',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
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
                  "I like to learn about...",
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
                padding: const EdgeInsets.only(
                  top: 40.0,
                ),
                child: CategoryChipSelectInput(
                  searchText: "search for academic interests",
                  onChange: onChanged,
                  map: academicInterestsOptionsList,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
