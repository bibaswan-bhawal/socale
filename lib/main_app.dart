import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/main/main_router_info_parser.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/service_providers.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final MainRouteInformationParser _mainRouteInformationParser = MainRouteInformationParser();

  @override
  void initState() {
    super.initState();

    ref.read(amplifyBackendServiceProvider).initAmplify();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'Socale',
        debugShowCheckedModeBanner: false,
        routerDelegate: ref.watch(mainRouterDelegateProvider),
        routeInformationParser: _mainRouteInformationParser,
      ),
    );
  }
}
