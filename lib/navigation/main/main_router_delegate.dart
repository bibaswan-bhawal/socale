import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/app_state.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/screens/auth/auth_router_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/screen_splash.dart';

class MainRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AutoDisposeProviderRef ref;

  AppState appState = AppState();
  AuthState authState = AuthState();

  MainRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    appState = ref.read(appStateProvider);
    authState = ref.read(authStateProvider);

    ref.listen(appStateProvider, updateAppState);
  }

  // Update App State
  void updateAuthState(AuthState? oldState, AuthState newState) {
    if (authState == newState) return;
    print('new auth state');
    authState = newState;
    notifyListeners();
  }

  void updateAppState(AppState? oldState, AppState newState) {
    if (appState == newState) return;
    appState = newState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (appState.isInitialized && !appState.isLoggedIn) {
      ref.listen(authStateProvider, updateAuthState);
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        if (!appState.isInitialized) const MaterialPage(child: SplashScreen()),
        if (appState.isInitialized) ...[
          if (!appState.isLoggedIn) const MaterialPage(child: AuthRouterScreen()),
          if (appState.isLoggedIn) const MaterialPage(child: OnboardingScreen()),
        ]
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }

  // new state update route path
  @override
  AppRoutePath get currentConfiguration {
    if (!appState.isInitialized) return MainRoutePath.splashScreen();
    if (appState.isInitialized && !appState.isLoggedIn) {
      return ref.read(authRouterDelegateProvider).getNewRoutePath(authState);
    }
    if (appState.isInitialized && appState.isLoggedIn) return MainRoutePath.app();
    return MainRoutePath.splashScreen();
  }

  // new route path requested update state
  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration is AuthRoutePath) {
      ref.read(authRouterDelegateProvider).newRouteRequested(configuration);
    }
  }
}
