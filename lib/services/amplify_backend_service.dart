import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/amplifyconfiguration.dart';
import 'package:socale/models/current_user.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/types/auth/auth_result.dart';

class AmplifyBackendService {
  ProviderRef ref;

  AmplifyBackendService(this.ref);

  initialize() async {
    if (Amplify.isConfigured) {
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

  configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      throw (Exception('Could not configure Amplify: $e'));
    }
  }

  attemptAutoLogin() async {
    final result = (await AuthService.autoLoginUser());
    switch (result) {
      case AuthFlowResult.success:
        successfulLogin();
        break;
      case AuthFlowResult.notAuthorized:
        ref.read(appStateProvider.notifier).signOut();
        break;
      default:
        break;
    }

    ref.read(appStateProvider.notifier).amplifyConfigured();
  }

  successfulLogin() async {
    final CurrentUser currentUser = ref.read(currentUserProvider);

    final (JsonWebToken idToken, JsonWebToken accessToken, String refreshToken) =
        await AuthService.getAuthTokens();

    currentUser.setTokens(
      idToken: idToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    ref.read(appStateProvider.notifier).login();
  }
}
