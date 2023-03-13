import 'dart:convert';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:http/http.dart' as http;

part 'onboarding_options_repository.g.dart';

@riverpod
Future<List<Major>> fetchMajors(FetchMajorsRef ref) async {
  final List<Major> majors = [];

  final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
  String college = idToken.groups.first;

  final response = await http.get(
    Uri.parse('${const String.fromEnvironment('BACKEND_URL')}/api/get_majors'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
      'college': college,
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((major) {
      majors.add(Major.fromJson(major));
    });
  }

  return majors;
}

@riverpod
Future<List<Minor>> fetchMinors(FetchMinorsRef ref) async {
  final List<Minor> minors = [];

  final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
  String college = idToken.groups.first;

  final response = await http.get(
    Uri.parse('${const String.fromEnvironment('BACKEND_URL')}/api/get_minors'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
      'college': college,
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    body.forEach((minor) {
      minors.add(Minor.fromJson(minor));
    });
  }

  return minors;
}
