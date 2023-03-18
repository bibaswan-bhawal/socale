import 'package:flutter/material.dart';
import 'package:socale/components/cards/chip_card.dart';

class ChipCardFormField extends FormField<List> {
  final String placeholder;
  final String searchHint;
  final double horizontalPadding;
  final List? options;

  ChipCardFormField({
    Key? key,
    required this.placeholder,
    required this.searchHint,
    required this.horizontalPadding,
    this.options,
    List? initialValue,
    FormFieldSetter<List>? onSaved,
    FormFieldValidator<List>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List> state) {
            return ChipCard(
              horizontalPadding: horizontalPadding,
              placeholder: placeholder,
              options: options,
              initialOptions: initialValue ?? [],
              searchHint: searchHint,
              onChanged: state.didChange,
            );
          },
        );
}
