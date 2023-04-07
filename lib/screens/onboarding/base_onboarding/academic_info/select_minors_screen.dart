import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/components/pickers/list_input_picker/list_input_picker.dart';
import 'package:socale/models/options/minor/minor.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class MinorPickerScreenBuilder extends InputPickerScreenBuilder {
  MinorPickerScreenBuilder({required this.selectedOptions});

  final List<Minor> selectedOptions;

  @override
  InputPickerScreen build() => MinorPickerScreen(
        onClosedCallback: onClosedCallback,
        selectedOptions: selectedOptions,
      );
}

class MinorPickerScreen extends InputPickerScreen {
  const MinorPickerScreen({
    super.key,
    required this.selectedOptions,
    required super.onClosedCallback,
  });

  final List<Minor> selectedOptions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinorPickerScreenState();
}

class _MinorPickerScreenState extends ConsumerState<MinorPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final minor = ref.watch(fetchMinorsProvider);

    return ListInputPicker<Minor>(
      data: minor.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => [],
      ),
      searchHintText: 'Search minors',
      selectedData: widget.selectedOptions,
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
