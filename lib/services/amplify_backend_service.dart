import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/amplifyconfiguration.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/utils/debug_print_statements.dart';

class AmplifyBackendService {
  static Future<void> configureAmplify(ref) async {
    DateTime startTime = DateTime.now();

    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
      printRunTime(startTime, "Amplify initialisation");
      attemptAutoLogin(ref);
    } catch (e) {
      safePrint(e);
    }
  }

  static Future<void> attemptAutoLogin(ref) async {
    final authResult = await AuthService.autoLoginUser();

    switch (authResult) {
      case AuthResult.success:
        ref.read(appStateProvider.notifier).login();
        break;
      case AuthResult.notAuthorized:
        ref.read(appStateProvider.notifier).signOut();
        break;
      default:
        print("Unknown error");
        break;
    }

    ref.read(appStateProvider.notifier).amplifyConfigured();
  }
}
