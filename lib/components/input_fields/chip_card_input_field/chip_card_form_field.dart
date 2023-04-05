import 'package:flutter/material.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/components/input_fields/chip_card_input_field/chip_card_input_field.dart';

class ChipCardFormField<T> extends FormField<List<T>> {
  ChipCardFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required InputPickerBuilder inputPicker,
    required String placeholder,
    required Function onChanged,
  }) : super(
          builder: (FormFieldState<List<T>> state) {
            return ChipCardInputField<T>(
              selectedData: initialValue ?? [],
              placeholder: placeholder,
              hasError: state.hasError,
              errorText: state.errorText,
              inputPicker: inputPicker,
              onChanged: (value) {
                state.didChange(value);
                onChanged(value);
              },
            );
          },
        );
}
