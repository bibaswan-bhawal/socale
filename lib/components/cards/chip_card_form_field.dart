import 'package:flutter/material.dart';
import 'package:socale/components/cards/chip_card.dart';

class ChipCardFormField<T extends Comparable> extends FormField<List<T>> {
  final String placeholder;
  final String searchHint;
  final double horizontalPadding;
  final List<T>? options;

  ChipCardFormField({
    Key? key,
    required this.placeholder,
    required this.searchHint,
    required this.horizontalPadding,
    this.options,
    List<T>? initialValue,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List> state) {
            return ChipCard<T>(
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
