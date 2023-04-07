import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/categorical_input_picker/categorical_input_picker.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/models/options/interest/interest.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class InterestsPickerScreenBuilder extends InputPickerScreenBuilder {
  InterestsPickerScreenBuilder();

  @override
  InputPickerScreen build() => InterestsPickerScreen(onClosedCallback: onClosedCallback);
}

class InterestsPickerScreen extends InputPickerScreen {
  const InterestsPickerScreen({
    super.key,
    required super.onClosedCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InterestsPickerScreenState();
}

class _InterestsPickerScreenState extends ConsumerState<InterestsPickerScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fetchInterestsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final interests = ref.watch(fetchInterestsProvider);
    final onboardingUser = ref.watch(onboardingUserProvider);

    return CategoricalInputPicker<Interest>(
      data: interests.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => const [],
      ),
      searchHintText: 'Search Interests',
      selectedData: onboardingUser.interests ?? [],
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
