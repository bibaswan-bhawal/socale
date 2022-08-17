// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/chips/category_chip_select/category_chip_select_input_list.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/options/describe.dart';
import 'package:socale/values/colors.dart';

class DescribePage extends StatefulWidget {
  const DescribePage({Key? key}) : super(key: key);

  @override
  State<DescribePage> createState() => _DescribePageState();
}

class _DescribePageState extends State<DescribePage> {
  List<String> describe = [];

  onChanged(List<String> skillsSelected) {
    setState(() => describe = skillsSelected);
    onboardingService.setSelfDescription(describe);
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
                        text: 'You are ',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Unique!',
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
                  "I would describe myself as...",
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
                child: CategoryChipSelectInputList(
                  onChange: onChanged,
                  list: descriptionOptionList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
