import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:socale/providers/service_providers.dart';

class SocaleApi {
  final ProviderRef ref;

  SocaleApi(this.ref);

  static const String _baseUrl = String.fromEnvironment('BACKEND_URL');

  Future<http.Response> sendRequest({required String endpoint, required Map<String, String>? headers}) async {
    final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();

    headers?.addAll({HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}'});

    return await http.get(
      Uri.parse('$_baseUrl/api/$endpoint'),
      headers: headers,
    );
  }
}
