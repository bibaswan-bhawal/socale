import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/components/pickers/list_input_picker/list_input_picker.dart';
import 'package:socale/models/options/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class MinorPickerScreenBuilder extends InputPickerScreenBuilder {
  MinorPickerScreenBuilder();

  @override
  InputPickerScreen build() => MinorPickerScreen(onClosedCallback: onClosedCallback);
}

class MinorPickerScreen extends InputPickerScreen {
  const MinorPickerScreen({
    super.key,
    required super.onClosedCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinorPickerScreenState();
}

class _MinorPickerScreenState extends ConsumerState<MinorPickerScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fetchMinorsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final minor = ref.watch(fetchMinorsProvider);
    final onboardingUser = ref.watch(onboardingUserProvider);

    return ListInputPicker<Minor>(
      data: minor.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => [],
      ),
      searchHintText: 'Search minors',
      selectedData: onboardingUser.minors ?? [],
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
