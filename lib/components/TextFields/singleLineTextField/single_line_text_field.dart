import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/values/styles.dart';

class SingleLineTextField extends StatelessWidget {
  final String hint;
  final String icon;
  final bool obscureText;

  const SingleLineTextField(
      {Key? key,
      required this.hint,
      required this.icon,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: StyleValues.textFieldContentStyle,
      cursorColor: const Color(0xFF000000),
      cursorRadius: Radius.circular(5),
      decoration: InputDecoration(
        hintStyle: StyleValues.textFieldHintStyle,
        prefixIcon: SvgPicture.asset(
          icon,
          fit: BoxFit.fitHeight,
        ),
        fillColor: const Color(0xFFFFFFFF).withOpacity(0.9),
        filled: true,
        prefixIconConstraints: BoxConstraints(minHeight: 18, minWidth: 48),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF000000),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF000000),
            width: 3,
          ),
        ),
        hintText: hint,
      ),
    );
  }
}
