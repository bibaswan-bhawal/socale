import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/pickers/input_picker_screen.dart';
import 'package:socale/components/pickers/list_input_picker/list_input_picker.dart';
import 'package:socale/models/options/language/language.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';

class LanguagePickerScreenBuilder extends InputPickerScreenBuilder {
  LanguagePickerScreenBuilder();

  @override
  InputPickerScreen build() => LanguagePickerScreen(onClosedCallback: onClosedCallback);
}

class LanguagePickerScreen extends InputPickerScreen {
  const LanguagePickerScreen({
    super.key,
    required super.onClosedCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends ConsumerState<LanguagePickerScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fetchLanguagesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final languages = ref.watch(fetchLanguagesProvider);
    final onboardingUser = ref.watch(onboardingUserProvider);

    return ListInputPicker<Language>(
      data: languages.when(
        data: (data) => data,
        loading: () => null,
        error: (error, stack) => const [],
      ),
      searchHintText: 'Search languages',
      selectedData: onboardingUser.languages ?? [],
      onClosedCallback: widget.onClosedCallback,
    );
  }
}
