import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/amplifyconfiguration.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';

class AmplifyBackendService {
  ProviderRef ref;

  AmplifyBackendService(this.ref);

  Future<void> initAmplify() async {
    if (Amplify.isConfigured) {
      attemptAutoLogin();
      return;
    }

    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
      attemptAutoLogin();
    } on AmplifyAlreadyConfiguredException {
      attemptAutoLogin();
    } catch (e) {
      throw (Exception('Could not configure Amplify: $e'));
    }
  }

  Future<void> attemptAutoLogin() async {
    final authResult = await AuthService.autoLoginUser();

    switch (authResult) {
      case AuthResult.success:
        ref.read(appStateProvider.notifier).login();
        break;
      case AuthResult.notAuthorized:
        ref.read(appStateProvider.notifier).signOut();
        break;
      default:
        throw (Exception('Could not auto login user'));
    }

    ref.read(appStateProvider.notifier).amplifyConfigured();
  }
}
