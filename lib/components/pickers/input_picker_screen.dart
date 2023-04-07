import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class InputPickerScreenBuilder {
  late Function onClosedCallback;

  InputPickerScreenBuilder();

  InputPickerScreen build();
}

abstract class InputPickerScreen extends ConsumerStatefulWidget {
  const InputPickerScreen({
    super.key,
    required this.onClosedCallback,
  });

  final Function onClosedCallback;
}

abstract class InputPickerScreenState extends ConsumerState<InputPickerScreen> {}
