import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/models/major/major.dart';

part 'onboarding_options_repository.g.dart';

@riverpod
Future<List<Major>> fetchMajors(FetchMajorsRef ref) async {
  return const <Major>[];
}

class OnboardingOptionsRepository {}
