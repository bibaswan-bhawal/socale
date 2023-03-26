import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/service_providers.dart';

class EmailVerificationService {
  final AutoDisposeProviderRef ref;
  final KeepAliveLink disposeLink;

  int? code;
  String? email;

  EmailVerificationService(this.ref) : disposeLink = ref.keepAlive();

  Future<void> sendCode(String email) async {
    code = Random().nextInt(1000000 - 100000) + 100000; // generate 6 digit random code
    this.email = email;

    if (kDebugMode) return print('Sending code: $code to $email');

    final response = await ref.read(apiServiceProvider).sendPostRequest(
          endpoint: 'user/verify/student?email=$email&code=$code',
        );

    if (response.statusCode == 200) return;

    throw Exception('There was a problem sending the code: $code to $email');
  }

  bool verifyCode(int code) => code == code;

  dispose() => disposeLink.close();
}
