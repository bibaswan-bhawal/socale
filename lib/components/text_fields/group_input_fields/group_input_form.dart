import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class GroupInputForm extends StatelessWidget {
  final List<Widget> children;
  final bool isError;
  final String errorMessage;

  const GroupInputForm({
    Key? key,
    this.children = const [],
    this.isError = false,
    this.errorMessage = '',
  }) : super(key: key);

  List<Widget> buildInputList() {
    List<Widget> inputs = [];

    for (var input in children) {
      inputs.add(input);

      if (input != children.last) {
        inputs.add(const Divider(height: 1.25, thickness: 1.25, color: Color(0x1A000000)));
      }
    }

    return inputs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isError ? Colors.red : Colors.transparent, width: 2),
            gradient: ColorValues.groupInputBackgroundGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: buildInputList(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedOpacity(
              opacity: isError ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                errorMessage,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(color: Colors.red, fontSize: 12, letterSpacing: -0.3),
              ),
            ),
          ),
        )
      ],
    );
  }
}
