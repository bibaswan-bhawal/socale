import 'package:flutter/material.dart';
import 'package:socale/components/text_fields/input_fields/date_input_field.dart';

class DateInputFormField extends FormField<DateTime> {
  final DateTime initialDate;
  final DateTime? maximumDate;
  final DateTime? minimumDate;

  final DatePickerDateMode dateMode;

  DateInputFormField({
    Key? key,
    required this.initialDate,
    this.maximumDate,
    this.minimumDate,
    this.dateMode = DatePickerDateMode.dayMonthYear,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
  }) : super(
          key: key,
          initialValue: initialDate,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<DateTime> state) {
            return DateInputField(
              initialDate: initialDate,
              maximumDate: maximumDate,
              minimumDate: minimumDate,
              dateMode: dateMode,
              onChanged: state.didChange,
            );
          },
        );
}
