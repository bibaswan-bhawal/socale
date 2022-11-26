import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class SingleInputForm extends StatefulWidget {
  final List<Widget> children;
  final bool isError;
  final String errorMessage;

  const SingleInputForm({
    Key? key,
    this.children = const [],
    this.isError = false,
    this.errorMessage = "",
  }) : super(key: key);

  @override
  State<SingleInputForm> createState() => _SingleInputFormState();
}

class _SingleInputFormState extends State<SingleInputForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: widget.isError ? Colors.red : Colors.transparent, width: 2),
            gradient: ColorValues.groupInputBackgroundGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 2,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return widget.children[index];
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: 1.5,
                color: Color(0xFFE7E7E7),
              );
            },
            itemCount: widget.children.length,
          ),
        ),
        AnimatedContainer(
          margin: EdgeInsets.only(left: 15, top: 8),
          width: double.infinity,
          duration: Duration(milliseconds: 100),
          child: Text(
            widget.errorMessage,
            textAlign: TextAlign.start,
            style: GoogleFonts.roboto(color: Colors.red),
          ),
        )
      ],
    );
  }
}
