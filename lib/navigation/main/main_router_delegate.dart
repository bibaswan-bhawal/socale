import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/models/state/app_state.dart';
import 'package:socale/models/state/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/navigation/main/pages/auth_page.dart';
import 'package:socale/navigation/main/pages/onboarding_page.dart';
import 'package:socale/navigation/main/pages/splash_page.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/state_providers.dart';

class MainRouterDelegate extends RouterDelegate<AppRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AutoDisposeProviderRef ref;

  AppState appState = AppState();
  AuthState authState = AuthState();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MainRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    appState = ref.read(appStateProvider);
    authState = ref.read(authStateProvider);

    ref.listen(appStateProvider, updateAppState);
  }

  // Update App State
  void updateAuthState(AuthState? oldState, AuthState newState) {
    if (authState == newState) return;
    authState = newState;
    notifyListeners();
  }

  void updateAppState(AppState? oldState, AppState newState) {
    if (appState == newState) return;
    appState = newState;
    if (appState.isInitialized && !appState.isLoggedIn) {
      ref.listen(authStateProvider, updateAuthState);
    }
    notifyListeners();
  }

  List<Page> buildPages() {
    if (!appState.isInitialized) return [const SplashPage()];
    if (!appState.isLoggedIn) return [const AuthPage()];

    return [const OnboardingPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LightBackground(),
        Navigator(
          key: navigatorKey,
          pages: buildPages(),
          onPopPage: (route, result) {
            return route.didPop(result);
          },
        ),
      ],
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
