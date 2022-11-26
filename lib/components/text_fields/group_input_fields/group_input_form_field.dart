import 'package:flutter/material.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_field.dart';

class GroupInputFormField extends FormField<String> {
  final String hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final bool isObscured;
  final Function(String)? onError;

  GroupInputFormField({
    Key? key,
    required this.hintText,
    this.textInputType,
    this.textInputAction,
    this.prefixIcon,
    this.isObscured = false,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String initialValue = "",
    this.onError,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return GroupInputField(
              hintText: hintText,
              initialValue: initialValue,
              textInputType: textInputType,
              textInputAction: textInputAction,
              prefixIcon: prefixIcon,
              isObscured: isObscured,
              onChanged: state.didChange,
            );
          },
        );
}
