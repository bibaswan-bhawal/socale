import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/categorical_input_picker/categorical_input_picker.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/models/options/club/club.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class ClubsPickerScreenBuilder extends InputPickerScreenBuilder {
  ClubsPickerScreenBuilder();

  @override
  InputPickerScreen build() => ClubsPickerScreen(onClosedCallback: onClosedCallback);
}

class ClubsPickerScreen extends InputPickerScreen {
  const ClubsPickerScreen({
    super.key,
    required super.onClosedCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClubsPickerScreenState();
}

class _ClubsPickerScreenState extends ConsumerState<ClubsPickerScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fetchClubsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(fetchClubsProvider);
    final onboardingUser = ref.watch(onboardingUserProvider);

    return CategoricalInputPicker<Club>(
      data: clubs.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => const [],
      ),
      searchHintText: 'Search clubs',
      selectedData: onboardingUser.clubs ?? [],
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
