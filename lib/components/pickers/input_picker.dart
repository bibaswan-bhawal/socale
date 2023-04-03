import 'package:flutter/cupertino.dart';

abstract class InputPickerBuilder {
  late Function onClosedCallback;
  late List? selectedOptions;

  InputPicker<T> build<T>();
}

abstract class InputPicker<T> extends StatefulWidget {
  final Function onClosedCallback;

  const InputPicker({
    super.key,
    required this.onClosedCallback,
  });
}
