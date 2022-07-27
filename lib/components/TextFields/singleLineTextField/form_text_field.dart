import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';

class FormTextField extends StatelessWidget {
  final String hint;
  final String icon;
  final bool obscureText;
  final Iterable<String> autoFillHints;
  final String? Function(String?)? validator;
  final Function(String?)? onSave;

  const FormTextField({
    Key? key,
    required this.hint,
    required this.onSave,
    required this.validator,
    required this.autoFillHints,
    this.obscureText = false,
    this.icon = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(bottom: 40),
      obscureText: obscureText,
      autofillHints: autoFillHints,
      onSaved: onSave,
      validator: validator,
      style: StyleValues.textFieldContentStyle,
      cursorColor: ColorValues.elementColor,
      cursorRadius: Radius.circular(5),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        hintStyle: StyleValues.textFieldHintStyle,
        prefixIcon: SvgPicture.asset(
          icon,
          fit: BoxFit.fitHeight,
        ),
        fillColor: ColorValues.formTextFieldBackgroundColor,
        filled: true,
        prefixIconConstraints:
            StyleValues.formTextFieldPrefixIconBoxConstraints,
        enabledBorder: StyleValues.formTextFieldOutlinedBorderEnabled,
        focusedBorder: StyleValues.formTextFieldOutlinedBorderFocused,
        errorBorder: StyleValues.formTextFieldOutlinedBorderError,
        focusedErrorBorder: StyleValues.formTextFieldOutlinedBorderErrorEnabled,
        hintText: hint,
      ),
    );
  }
}
