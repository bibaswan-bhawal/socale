import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:http/http.dart' as http;

class SocaleApi {
  final ProviderRef ref;

  SocaleApi(this.ref);

  static const String _baseUrl = String.fromEnvironment('BACKEND_URL');

  Future<http.Response> sendGetRequest({required String endpoint, Map<String, String>? headers}) async {
    final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();

    Map<String, String> requestHeader = {HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}'};

    if (headers != null) requestHeader.addAll(headers);

    final response = await http.get(Uri.parse('$_baseUrl/api/$endpoint'), headers: requestHeader);

    return response;
  }

  Future<http.Response> sendPostRequest({required String endpoint, Map<String, String>? headers, Object? body}) async {
    final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();

    Map<String, String> requestHeader = {HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}'};

    if (headers != null) requestHeader.addAll(headers);

    final response = await http.post(Uri.parse('$_baseUrl/api/$endpoint'), headers: requestHeader, body: body);

    return response;
  }
}
