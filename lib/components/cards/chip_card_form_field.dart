import 'package:flutter/material.dart';
import 'package:socale/components/cards/chip_card.dart';

class ChipCardFormField extends FormField<List<String>> {
  final String emptyMessage;
  final String searchHint;
  final double height;
  final double horizontalPadding;
  final List<String> options;

  ChipCardFormField({
    Key? key,
    required this.emptyMessage,
    required this.searchHint,
    required this.height,
    required this.horizontalPadding,
    required this.options,
    List<String>? initialValue,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List<String>> state) {
            return ChipCard(
              height: height,
              horizontalPadding: horizontalPadding,
              emptyMessage: emptyMessage,
              options: options,
              initialOptions: initialValue ?? [],
              searchHint: searchHint,
              onChanged: state.didChange,
            );
          },
        );
}
