import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/screen_get_started.dart';
import 'package:socale/screens/screen_splash.dart';
import 'package:socale/state_machines/states/app_state.dart';

class MainRouterDelegate extends RouterDelegate<MainRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef ref;

  AppState appState;

  MainRouterDelegate(WidgetRef widgetRef)
      : ref = widgetRef,
        navigatorKey = GlobalKey<NavigatorState>(),
        appState = widgetRef.read(appStateProvider) {
    // listen to state changes
    ref.listen(appStateProvider, updateAppState);
  }

  void updateAppState(oldState, newState) {
    appState = newState;
    notifyListeners();
  }

  @override
  MainRoutePath get currentConfiguration {
    if (!appState.isAppInitialized()) return MainRoutePath.splashScreen();
    if (appState.isAppInitialized()) return MainRoutePath.getStartedScreen();

    return MainRoutePath.unknown();
  }

  @override
  Future<void> setNewRoutePath(MainRoutePath configuration) async {
    if (configuration.isUnknown) {
      updateAppState(appState, AppState(isAmplifyConfigured: false, isLocalDBConfigured: true));
    }

    if (configuration.isGetStarted) {
      updateAppState(appState, AppState(isAmplifyConfigured: true, isLocalDBConfigured: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!appState.isAppInitialized()) MaterialPage(child: SplashScreen()),
        if (appState.isAppInitialized()) MaterialPage(child: GetStartedScreen()),
      ],
      onPopPage: (route, result) {
        print("bob");

        if (!route.didPop(result)) {
          return false;
        }

        appState = AppState();
        notifyListeners();

        return false;
      },
    );
  }
}
