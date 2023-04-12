import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';

class InitService {
  ProviderRef ref;

  InitService(this.ref);

  Future<void> initialize() async {
    DateTime startTime = DateTime.now();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await Future.wait([
        ref.read(amplifyServiceProvider).configureAmplify(),
        ref.read(dbServiceProvider).configureDb(),
      ]);

      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        await prefs.setBool('isFirstTime', false);
        ref.read(appStateProvider.notifier).showIntro(true);
        ref.read(appStateProvider.notifier).setAttemptAutoLogin();
        ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
      } else {
        await ref.read(amplifyServiceProvider).attemptAutoLogin();
      }

      // ignore: avoid_print
      print('InitService.initialize() took ${DateTime.now().difference(startTime).inMilliseconds}ms');

      FlutterNativeSplash.remove();
    } catch (e) {
      if (kDebugMode) print('Error initialising services: $e');
      ref.read(appStateProvider.notifier).setInitError(true);
    }
  }
}
