import 'package:flutter/material.dart';
import 'chip_input_field.dart';

class ChipInputTextField<T> extends FormField<List<T>> {
  final InputDecoration decoration;
  final String textInputLabel;
  final double width;

  ChipInputTextField(
      {Key? key,
      required this.textInputLabel,
      required this.width,
      this.decoration = const InputDecoration(),
      FormFieldSetter<List>? onSaved,
      FormFieldValidator<List>? validator})
      : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List> field) {
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value?.isEmpty ?? true,
              child: ChipInputField(
                width: width,
                textInputLabel: textInputLabel,
                values: field.value?.map((e) => e.toString()).toList() ?? [],
                onChanged: field.didChange,
              ),
            );
          },
        );
}
