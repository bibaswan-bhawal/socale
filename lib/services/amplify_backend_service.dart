import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/amplifyconfiguration.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/utils/debug_print_statements.dart';

class AmplifyBackendService {
  static Future<void> configureAmplify(WidgetRef ref) async {
    DateTime startTime = DateTime.now();

    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin]);
    await Amplify.configure(amplifyconfig);

    ref.read(appStateProvider.notifier).amplifyConfigured();

    printRunTime(startTime, "Amplify initialisation");
  }
}
