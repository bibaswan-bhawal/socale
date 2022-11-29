import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/state_machines/auth_state_machine.dart';
import 'package:socale/utils/routes.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    ref.read(notificationServiceProvider).initNotificationService();
    ref.read(amplifyBackendServiceProvider).configureAmplify();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard at start
  }

  void onAppInitialized(_, state) async {
    print(state);
    if (state) {
      final result = await AuthService.autoLoginUser();
      ref.read(authStateProvider.notifier).state = result;
    }
  }

  void onAuthStateChange(oldState, newState) {
    print("auth state changed: $newState");

    if (navigatorKey.currentContext == null) {
      return;
    }

    final newScreen = AuthStateMachine().getStateAction(newState);

    if (newScreen != null) {
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        newScreen,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, onAuthStateChange);
    ref.listen(appInitializerStateProvider, onAppInitialized);

    return mainUIBuilder();
  }

  Widget mainUIBuilder() {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: Themes.materialAppThemeData,
        debugShowCheckedModeBanner: false,
        title: 'Socale',
        initialRoute: Routes.main,
        routes: Routes.appRoutes,
      ),
    );
  }
}
