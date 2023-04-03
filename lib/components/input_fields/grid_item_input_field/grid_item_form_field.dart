import 'package:flutter/material.dart';
import 'package:socale/components/input_fields/grid_item_input_field/grid_item_input_field.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/resources/colors.dart';

class GridItemFormField<T> extends FormField<List<T>> {
  GridItemFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required Widget icon,
    required String title,
    required List<T> data,
    required List<T>? initialData,
    required InputPickerBuilder inputPicker,
    double? borderSize,
    double? borderRadius,
    LinearGradient? borderGradient,
  }) : super(
          builder: (FormFieldState<List<T>> state) {
            return GridItemInputField<T>(
              icon: icon,
              title: title,
              data: data,
              initialData: initialData ?? [],
              borderSize: borderSize ?? 2,
              borderRadius: borderRadius ?? 15,
              borderGradient: borderGradient ?? AppColors.orangeGradient,
              inputPicker: inputPicker,
              onChanged: state.didChange,
            );
          },
        );
}
