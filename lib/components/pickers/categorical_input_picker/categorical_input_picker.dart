import 'package:flutter/material.dart';
import 'package:socale/components/pickers/input_picker.dart';

class CategoricalInputPickerBuilder<T> extends InputPickerBuilder {
  @override
  InputPicker<S> build<S>() {
    return CategoricalInputPicker<S>(
      onClosedCallback: onClosedCallback,
    );
  }
}

class CategoricalInputPicker<T> extends InputPicker<T> {
  const CategoricalInputPicker({
    super.key,
    required super.onClosedCallback,
  });

  @override
  State<CategoricalInputPicker<T>> createState() => CategoricalInputPickerState<T>();
}

class CategoricalInputPickerState<T> extends State<CategoricalInputPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
