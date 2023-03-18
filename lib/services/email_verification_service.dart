import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';

class EmailVerificationService {
  final AutoDisposeProviderRef ref;
  final KeepAliveLink disposeLink;

  int? otp;
  String? email;

  EmailVerificationService(this.ref) : disposeLink = ref.keepAlive();

  Future<bool> sendCode(String email) async {
    otp = Random().nextInt(1000000 - 100000) + 100000; // generate 6 digit random code
    this.email = email;

    final response = await ref.read(apiServiceProvider).sendRequest(
      endpoint: 'send_college_verify_email',
      headers: {
        'email': email,
        'code': otp.toString(),
      },
    );

    if (response.statusCode == 200) return true;
    return false;
  }

  bool verifyCode(int code) => otp == code;

  Future<bool> verifyCollegeEmailValid(String email) async {
    final response = await ref.read(apiServiceProvider).sendRequest(
      endpoint: 'verify_college_email',
      headers: {'email': email},
    );

    if (response.statusCode != 200) return false;

    List colleges = jsonDecode(response.body); // This should only ever return 1 item

    // TODO: probably use pattern matching here for cleaner code

    if (colleges.isEmpty) return false;

    College college = College.fromJson(colleges.first);

    ref.read(onboardingUserProvider.notifier).setCollege(college: college);

    return true;
  }

  dispose() => disposeLink.close();
}
