import 'package:flutter/material.dart';
import 'package:socale/components/pickers/chip_option_picker/chip_option_picker.dart';

class ChipOptionPickerFormField<T> extends FormField<List<T>> {
  final String placeholder;
  final String searchHint;
  final double horizontalPadding;
  final List<T>? options;

  final Function onChanged;

  ChipOptionPickerFormField({
    Key? key,
    required this.placeholder,
    required this.searchHint,
    required this.horizontalPadding,
    required this.onChanged,
    required this.options,
    List<T>? initialValue,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List<T>> state) {
            return ChipOptionPicker<T>(
              data: options,
              selectedData: initialValue ?? [],
              placeholder: placeholder,
              searchHintText: searchHint,
              hasError: state.hasError,
              errorText: state.errorText,
              onChanged: (value) {
                state.didChange(value);
                onChanged(value);
              },
            );
          },
        );
}
