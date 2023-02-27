import 'package:flutter/material.dart';
import 'package:socale/components/text_fields/input_fields/text_input_field.dart';

class TextInputFormField extends FormField<String> {
  final String hintText;

  final bool isObscured;

  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  final Iterable<String> autofillHints;

  final Function(String)? onError;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  TextInputFormField({
    Key? key,
    required this.hintText,
    this.isObscured = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints = const [],
    this.prefixIcon,
    this.suffixIcon,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.onError,
    String initialValue = '',
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return TextInputField(
              hintText: hintText,
              isObscured: isObscured,
              initialValue: initialValue,
              textInputType: textInputType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              prefixIcon: prefixIcon,
              autofillHints: autofillHints,
              onChanged: state.didChange,
            );
          },
        );
}