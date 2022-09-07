// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'chip_input_field.dart';

class ChipInputTextField<T> extends FormField<List<String>> {
  final InputDecoration decoration;
  final String textInputLabel;
  final double width;
  final List<String> list;
  final List<String> values;
  final Function onChangeCallback;

  ChipInputTextField({
    Key? key,
    required this.textInputLabel,
    required this.width,
    this.decoration = const InputDecoration(),
    required FormFieldSetter<List<String>>? onSaved,
    required FormFieldValidator<List<String>>? validator,
    required this.values,
    required this.list,
    required this.onChangeCallback,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List> field) {
            final InputDecoration effectiveDecoration = decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            field.setValue(values);

            return InputDecorator(
              decoration: effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value?.isEmpty ?? true,
              child: ChipInputField(
                width: width,
                list: list,
                textInputLabel: textInputLabel,
                values: field.value?.map((e) => e.toString()).toList() ?? values,
                onChanged: (value) {
                  onChangeCallback(value);
                  field.didChange(value);
                },
              ),
            );
          },
        );
}
