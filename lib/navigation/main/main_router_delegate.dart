import 'package:flutter/material.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/auth_router_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/screen_splash.dart';
import 'package:socale/state_machines/states/app_state.dart';

class MainRouterDelegate extends RouterDelegate<MainRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppState appState;

  MainRouterDelegate(ref)
      : navigatorKey = GlobalKey<NavigatorState>(),
        appState = ref.read(appStateProvider) {
    ref.listen(appStateProvider, updateAppState);
  }

  void updateAppState(oldState, newState) {
    appState = newState;
    notifyListeners();
  }

  @override
  MainRoutePath get currentConfiguration {
    if (!appState.isInitialized()) return MainRoutePath.splashScreen();
    if (appState.isInitialized() && !appState.isLoggedIn) return MainRoutePath.auth();
    if (appState.isInitialized() && appState.isLoggedIn) return MainRoutePath.app();
    return MainRoutePath.splashScreen();
  }

  @override
  Future<void> setNewRoutePath(MainRoutePath configuration) async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!appState.isInitialized()) MaterialPage(child: SplashScreen()),
        if (appState.isInitialized() && !appState.isLoggedIn)
          MaterialPage(child: AuthRouterScreen()),
        if (appState.isInitialized() && appState.isLoggedIn)
          MaterialPage(child: OnboardingScreen()),
      ],
      onPopPage: (route, result) {
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
