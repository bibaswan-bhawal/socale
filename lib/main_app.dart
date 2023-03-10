import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/main_navigation/main_router_info_parser.dart';
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
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard at start
     
    ref.read(amplifyBackendServiceProvider).initialize();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'Socale',
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routerDelegate: ref.watch(mainRouterDelegateProvider),
        routeInformationParser: _mainRouteInformationParser,
      ),
    );
  }
}
