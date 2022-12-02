import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_router_delegate.dart';
import 'package:socale/navigation/auth/auth_router_info_parser.dart';
import 'package:socale/navigation/main/main_router_delegate.dart';
import 'package:socale/navigation/main/main_router_info_parser.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/navigation/routes.dart';

import 'state_machines/states/app_state.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    ref.read(amplifyBackendServiceProvider).configureAmplify();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(), // dismiss keyboard on tap
      child: MaterialApp.router(
        theme: Themes.materialAppThemeData,
        debugShowCheckedModeBanner: false,
        title: 'Socale',
        routerDelegate: AuthRouterDelegate(ref),
        routeInformationParser: AuthRouteInformationParser(),
      ),
    );
  }
}
