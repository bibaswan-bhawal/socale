import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:socale/models/college.dart';
import 'package:socale/providers/model_providers.dart';

class EmailVerificationService {
  AutoDisposeProviderRef ref;

  KeepAliveLink? disposeLink;

  int? otp;
  String? email;

  EmailVerificationService(this.ref) {
    disposeLink = ref.keepAlive();
  }

  Future<bool> sendCode(String email) async {
    otp = Random().nextInt(1000000 - 10000) + 100000;
    this.email = email;

    JsonWebToken idToken = ref.read(currentUserProvider).idToken;

    final response = await http.get(
      Uri.parse('${const String.fromEnvironment("BACKEND_URL")}/send_college_verification_email'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
        'email': email,
        'code': otp.toString(),
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) return true;
    return false;
  }

  Future<bool> verifyCode(int code) async {
    if (otp == code) return true;
    return false;
  }

  Future<bool> verifyCollegeEmailValid(String email) async {
    JsonWebToken idToken = ref.read(currentUserProvider).idToken;

    final response = await http.get(
      Uri.parse('${const String.fromEnvironment("BACKEND_URL")}/get_college_name'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
        'email': email,
      },
    );

    List colleges = jsonDecode(response.body); // This should only ever return 1 item

    if (colleges.isEmpty) return false;

    College college = College.fromJson(colleges.first);

    ref.read(onboardingUserProvider.notifier).setCollege(college: college);

    return true;
  }

  dispose() {
    disposeLink?.close();
  }
}
