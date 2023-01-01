import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/providers/state_notifiers/app_state.dart';
import 'package:socale/providers/state_notifiers/auth_state.dart';
import 'package:socale/screens/auth/auth_router_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/screen_splash.dart';
import 'package:socale/types/auth/auth_action.dart';

class MainRouterDelegate extends RouterDelegate<AppRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  WidgetRef ref;

  AppState appState;
  AuthState authState;

  MainRouterDelegate(this.ref)
      : navigatorKey = GlobalKey<NavigatorState>(),
        appState = ref.read(appStateProvider),
        authState = ref.read(authStateProvider) {
    ref.listen(appStateProvider, updateAppState);
    ref.listen(authStateProvider, updateAuthState);
  }

  void updateAuthState(_, AuthState newState) {
    if (authState.notVerified != newState.notVerified ||
        authState.resetPassword != newState.resetPassword ||
        authState.authAction != newState.authAction) {
      safePrint('updatedAuth');
      authState = newState;
      notifyListeners();
    }
  }

  void updateAppState(AppState? oldState, AppState newState) {
    if (appState.isInitialized() != newState.isInitialized() || appState.isLoggedIn != newState.isLoggedIn) {
      safePrint('updatedApp');
      appState = newState;
      notifyListeners();
    }
  }

  @override
  AppRoutePath get currentConfiguration {
    if (!appState.isInitialized()) return MainRoutePath.splashScreen();
    if (appState.isInitialized() && !appState.isLoggedIn) return authRouterCurrentConfiguration;
    if (appState.isInitialized() && appState.isLoggedIn) return MainRoutePath.app();
    return MainRoutePath.splashScreen();
  }

  AuthRoutePath get authRouterCurrentConfiguration {
    if (authState.notVerified) return AuthRoutePath.verifyEmail(authState.authAction);
    if (authState.resetPassword) return AuthRoutePath.forgotPassword();

    switch (authState.authAction) {
      case AuthAction.noAction:
        return AuthRoutePath.getStarted();
      case AuthAction.signIn:
        return AuthRoutePath.signIn();
      case AuthAction.signUp:
        return AuthRoutePath.signUp();
    }
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration is AuthRoutePath) {
      AuthState state = configuration.appState;
      ref.read(authStateProvider.notifier).setAuthAction(state.authAction);
      ref.read(authStateProvider.notifier).resetPassword(state.resetPassword);
      ref.read(authStateProvider.notifier).verifyEmail(false);
    }
  }

  List<Page> pageBuilder() {
    if (!appState.isInitialized()) return [MaterialPage(child: SplashScreen())];
    if (!appState.isLoggedIn) return [MaterialPage(child: AuthRouterScreen())];
    return [MaterialPage(child: OnboardingScreen())];
  }

  @override
  Widget build(BuildContext context) {
    safePrint("build");
    return Navigator(
      key: navigatorKey,
      pages: pageBuilder(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        return route.didPop(result);
      },
    );
  }
}
