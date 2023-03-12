import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/models/onboarding_options/onboarding_options_data.dart';

part 'onboarding_options_repository.g.dart';

@riverpod
class OnboardingOptionsRepository extends _$OnboardingOptionsRepository {
  

  @override
  FutureOr<OnboardingOptionsData> build() async {
    return const OnboardingOptionsData();
  }
}
