import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/TextFields/chip_input/chip_input_text_field.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/options/colleges.dart';
import 'package:socale/utils/options/major_minor.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';

class AcademicsPage extends StatefulWidget {
  final PageController pageController;
  final GlobalKey<FormState> majorKey;
  final GlobalKey<FormState> minorKey;
  final GlobalKey<FormState> collegeKey;
  final Function(List<String>?) majorOnSave;
  final Function(List<String>?) minorOnSave;
  final Function(List<String>?) collegeOnSave;

  const AcademicsPage({
    Key? key,
    required this.pageController,
    required this.majorKey,
    required this.minorKey,
    required this.collegeKey,
    required this.majorOnSave,
    required this.minorOnSave,
    required this.collegeOnSave,
  }) : super(key: key);

  @override
  State<AcademicsPage> createState() => AcademicsPageState();
}

class AcademicsPageState extends State<AcademicsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 70, 40, 0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Let's find you some ",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'classmates!',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = ColorValues.socaleOrangeGradient,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
            child: Image.asset("assets/images/onboarding_illustration_4.png"),
          ),
        ),
        Expanded(
          child: PageView(
            controller: widget.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 100,
                child: Form(
                  key: widget.majorKey,
                  child: SizedBox(
                    height: 20,
                    width: size.width,
                    child: ChipInputTextField(
                      list: majorsMinorOptionsList,
                      width: size.width - 48,
                      textInputLabel: "Majors",
                      decoration: InputDecoration(
                        border: StyleValues.chipFieldBorder,
                      ),
                      validator: (values) {
                        if (values == null) {
                          return "Please select at least one major";
                        }
                        if (values.isEmpty) {
                          return "Please add at least one major";
                        }

                        if (values.length > 2) {
                          return "Please add only 2 majors";
                        }

                        return null;
                      },
                      onSaved: widget.majorOnSave,
                    ),
                  ),
                ),
              ),
              Form(
                key: widget.minorKey,
                child: ChipInputTextField(
                  list: majorsMinorOptionsList,
                  width: size.width - 48,
                  textInputLabel: "Minor",
                  decoration: InputDecoration(
                    border: StyleValues.chipFieldBorder,
                  ),
                  validator: (values) => null,
                  onSaved: widget.minorOnSave,
                ),
              ),
              Form(
                key: widget.collegeKey,
                child: ChipInputTextField(
                  list: collegesOptionsList,
                  width: size.width - 48,
                  textInputLabel: "colleges",
                  decoration: InputDecoration(
                    border: StyleValues.chipFieldBorder,
                  ),
                  validator: (values) {
                    if (values == null) {
                      return "Please select a college";
                    }

                    if (values.isEmpty) {
                      return "Please select a college";
                    }

                    if (values.length > 1) {
                      return "Please only add one college";
                    }

                    return null;
                  },
                  onSaved: widget.collegeOnSave,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
