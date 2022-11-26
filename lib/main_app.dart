import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/utils/routes.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int mainScreenController = 0; // Page controller

  bool isAmplifyConfigured = false;
  bool isDatabaseLoaded = false;

  @override
  void initState() {
    super.initState();

    ref.read(notificationServiceProvider).initNotificationService();
    ref.read(amplifyBackendServiceProvider).configureAmplify();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onAppInitialized(_, state) {
    if (state == true) {
      if (navigatorKey.currentContext == null) {
        throw ("Material App has not been initialized before trying to get navigator context");
      }

      Navigator.pushReplacementNamed(navigatorKey.currentContext!, Routes.getStarted);
    }
  }

  @override
  Widget build(BuildContext context) {
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
