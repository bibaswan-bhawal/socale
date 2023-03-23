import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/results/auth_flow_result.dart';
import 'package:socale/amplifyconfiguration.dart';

class AmplifyBackendService {
  final ProviderRef ref;

  const AmplifyBackendService(this.ref);

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
    try {
      final result = await ref.read(authServiceProvider).autoLoginUser();

      switch (result) {
        case AuthFlowResult.success:
          await ref.read(authServiceProvider).loginSuccessful();
          break;
        default:
          ref.read(authServiceProvider).signOutUser();
          break;
      }
    } on UserNotFoundException {
      ref.read(authServiceProvider).signOutUser();
    } catch (e) {
      rethrow;
    }

    ref.read(appStateProvider.notifier).setAttemptAutoLogin();
  }
}
