import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/components/pickers/list_input_picker/list_input_picker.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class MajorPickerScreenBuilder extends InputPickerScreenBuilder {
  MajorPickerScreenBuilder();

  @override
  InputPickerScreen build() => MajorPickerScreen(onClosedCallback: onClosedCallback);
}

class MajorPickerScreen extends InputPickerScreen {
  const MajorPickerScreen({
    super.key,
    required super.onClosedCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MajorsPickerScreenState();
}

class _MajorsPickerScreenState extends ConsumerState<MajorPickerScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fetchMajorsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final majors = ref.watch(fetchMajorsProvider);
    final onboardingUser = ref.watch(onboardingUserProvider);

    return ListInputPicker<Major>(
      data: majors.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => const [],
      ),
      searchHintText: 'Search majors',
      selectedData: onboardingUser.majors ?? [],
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
