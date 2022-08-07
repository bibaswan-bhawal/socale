import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/TextFields/chip_input/chip_input_text_field.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';

class AcademicsPage extends StatefulWidget {
  const AcademicsPage({required Key key}) : super(key: key);

  @override
  State<AcademicsPage> createState() => AcademicsPageState();
}

class AcademicsPageState extends State<AcademicsPage> {
  final _controller = PageController(initialPage: 0);
  final _majorKey = GlobalKey<FormState>();
  final _minorKey = GlobalKey<FormState>();

  late List _majors = [];
  late List _minors = [];

  void nextPage() {
    _controller.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void previousPage() {
    _controller.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 80, 40, 0),
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
                      foreground: Paint()..shader = ColorValues.socaleOrange,
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
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Form(
                key: _majorKey,
                child: ChipInputTextField(
                  width: size.width - 48,
                  textInputLabel: "Majors",
                  decoration: InputDecoration(
                    border: StyleValues.chipFieldBorder,
                  ),
                  validator: (values) =>
                      (values?.length ?? 0) < 3 ? 'Please add a major' : null,
                  onSaved: (values) {
                    _majors = values!;
                  },
                ),
              ),
              Form(
                key: _minorKey,
                child: ChipInputTextField(
                  width: size.width - 48,
                  textInputLabel: "Minor",
                  decoration: InputDecoration(
                    border: StyleValues.chipFieldBorder,
                  ),
                  validator: (values) =>
                      (values?.length ?? 0) < 3 ? 'Please add a minor' : null,
                  onSaved: (values) {
                    _minors = values!;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
