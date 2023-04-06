import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/models/options/clubs/clubs.dart';
import 'package:socale/models/options/interests/interests.dart';
import 'package:socale/models/options/language/language.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/models/options/minor/minor.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';

part 'onboarding_options_repository.g.dart';

@riverpod
Future<List<Major>> fetchMajors(FetchMajorsRef ref) async {
  final List<Major> majors = [];

  final onboardingUser = ref.read(onboardingUserProvider);
  final apiService = ref.read(apiServiceProvider);

  if (onboardingUser.college == null) throw Exception('College is null!');

  final response = await apiService.sendGetRequest(endpoint: 'colleges/${onboardingUser.college!.id}/majors');

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

  final response = await apiService.sendGetRequest(endpoint: 'colleges/${onboardingUser.college!.id}/minors');

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

@riverpod
Future<List<Language>> fetchLanguages(FetchLanguagesRef ref) async {
  final List<Language> languages = [];

  final apiService = ref.read(apiServiceProvider);

  final response = await apiService.sendGetRequest(endpoint: 'app/getLanguages');

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((language) {
      languages.add(Language.fromJson(language));
    });
  } else {
    throw Exception('Failed to fetch languages');
  }

  return languages;
}

@riverpod
Future<List<Interest>> fetchInterests(FetchInterestsRef ref) async {
  final List<Interest> interests = [];

  final apiService = ref.read(apiServiceProvider);

  final response = await apiService.sendGetRequest(endpoint: 'app/getInterests');

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    print('body: $body');

    body.forEach((interest) {
      interests.add(Interest.fromJson(interest));
    });
  } else {
    throw Exception('Failed to fetch interests');
  }

  return interests;
}

@riverpod
Future<List<Club>> fetchClubs(FetchClubsRef ref) async {
  final List<Club> clubs = [];

  final onboardingUser = ref.read(onboardingUserProvider);
  final apiService = ref.read(apiServiceProvider);

  if (onboardingUser.college == null) throw Exception('College is null!');

  final response = await apiService.sendGetRequest(endpoint: 'colleges/${onboardingUser.college!.id}/clubs');

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((interest) {
      clubs.add(Club.fromJson(interest));
    });
  } else {
    throw Exception('Failed to fetch clubs');
  }

  return clubs;
}
