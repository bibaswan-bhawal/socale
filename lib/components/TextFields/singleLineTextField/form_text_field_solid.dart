import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';

class FormTextFieldSolid extends StatelessWidget {
  final String hint;
  final String icon;
  final bool obscureText;
  final Iterable<String> autoFillHints;
  final String? Function(String?)? validator;
  final Function(String?)? onSave;
  final TextInputAction textInputAction;

  const FormTextFieldSolid({
    Key? key,
    required this.hint,
    required this.icon,
    required this.obscureText,
    required this.autoFillHints,
    this.validator,
    this.onSave,
    required this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF000000).withOpacity(0.48),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: TextFormField(
            textInputAction: textInputAction,
            obscureText: obscureText,
            autofillHints: autoFillHints,
            onSaved: onSave,
            validator: validator,
            style: GoogleFonts.poppins(
              letterSpacing: -0.3,
              fontSize: 14,
              color: ColorValues.textOnDark,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                letterSpacing: -0.3,
                fontSize: 14,
                color: ColorValues.textOnDark.withOpacity(0.69),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
