import 'package:flutter/material.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_field.dart';

class GroupInputFormField extends FormField<String> {
  final String hintText;

  final bool isObscured;

  final TextInputType textInputType;
  final TextInputAction textInputAction;

  final Iterable<String> autofillHints;

  final Function(String)? onError;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  GroupInputFormField({
    Key? key,
    required this.hintText,
    this.isObscured = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
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
            return GroupInputField(
              hintText: hintText,
              isObscured: isObscured,
              initialValue: initialValue,
              textInputType: textInputType,
              textInputAction: textInputAction,
              prefixIcon: prefixIcon,
              autofillHints: autofillHints,
              onChanged: state.didChange,
            );
          },
        );
}
