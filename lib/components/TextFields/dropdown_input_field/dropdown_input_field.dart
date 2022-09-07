// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:socale/components/TextFields/dropdown_input_field/dropdown_text_field.dart';

class DropDownInputField<T> extends FormField<String> {
  final InputDecoration decoration;
  final List<String> list;
  final Function onChange;
  final String initValue;
  final String label;

  DropDownInputField({
    Key? key,
    this.decoration = const InputDecoration(),
    required this.list,
    required this.onChange,
    required this.initValue,
    required this.label,
    required FormFieldSetter<String>? onSaved,
    required FormFieldValidator<String>? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<String> field) {
            final InputDecoration effectiveDecoration = decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            field.setValue(initValue);

            return InputDecorator(
              decoration: effectiveDecoration.copyWith(errorText: field.errorText),
              child: DropDownTextField(
                label: label,
                initValue: initValue,
                list: list,
                onChange: (value) {
                  onChange(value);
                  field.didChange(value);
                },
              ),
            );
          },
        );
}
