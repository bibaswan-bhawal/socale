import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';

part 'onboarding_options_repository.g.dart';

@riverpod
Future<List<Major>> fetchMajors(FetchMajorsRef ref) async {
  final List<Major> majors = [];

  final onboardingUser = ref.read(onboardingUserProvider);
  final apiService = ref.read(apiServiceProvider);

  if (onboardingUser.college == null) throw Exception('College is null!');

  final response = await apiService.sendGetRequest(
    endpoint: 'colleges/${onboardingUser.college!.id}/majors',
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((major) {
      majors.add(Major.fromJson(major));
    });
  } else {
    throw Exception('Failed to fetch majors');
  }

  return majors;
}

@riverpod
Future<List<Minor>> fetchMinors(FetchMinorsRef ref) async {
  final List<Minor> minors = [];

  final onboardingUser = ref.read(onboardingUserProvider);
  final apiService = ref.read(apiServiceProvider);

  if (onboardingUser.college == null) throw Exception('College is null!');

  final response = await apiService.sendGetRequest(
    endpoint: 'colleges/${onboardingUser.college!.id}/minors',
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((minor) {
      minors.add(Minor.fromJson(minor));
    });
  } else {
    throw Exception('Failed to fetch minors');
  }

  return minors;
}
