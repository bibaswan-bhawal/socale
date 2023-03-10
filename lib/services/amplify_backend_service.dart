import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_result.dart';
import 'package:socale/amplifyconfiguration.dart';

class AmplifyBackendService {
  final ProviderRef ref;

  const AmplifyBackendService(this.ref);

  Future<void> initialize() async {
    if (Amplify.isConfigured) {
      ref.read(appStateProvider.notifier).setAmplifyConfigured();
      attemptAutoLogin();
      return;
    }

    try {
      await configureAmplify();
      attemptAutoLogin();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
      ref.read(appStateProvider.notifier).setAmplifyConfigured();
    } catch (e) {
      throw (Exception('Could not configure Amplify: $e'));
    }
  }

  Future<void> attemptAutoLogin() async {
    final result = await ref.read(authServiceProvider).autoLoginUser();

    switch (result) {
      case AuthFlowResult.success:
        final userAttributes = await Amplify.Auth.fetchUserAttributes();
        final userEmail =
            (userAttributes.firstWhere((element) => element.userAttributeKey == CognitoUserAttributeKey.email)).value;
        await ref.read(authServiceProvider).loginSuccessful(userEmail);
        break;
      case AuthFlowResult.notAuthorized:
        ref.read(appStateProvider.notifier).setLoggedOut();
        break;
      default:
        break;
    }
    ref.read(appStateProvider.notifier).setAttemptAutoLogin();
  }
}
