import 'package:flutter/cupertino.dart';

abstract class InputPicker<T> extends StatefulWidget {
  final Function onClosedCallback;

  const InputPicker({
    super.key,
    required this.onClosedCallback,
  });
}
