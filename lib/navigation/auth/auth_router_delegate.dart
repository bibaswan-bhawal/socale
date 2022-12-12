import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/screen_get_started.dart';
import 'package:socale/state_machines/state_values/auth/auth_action_value.dart';
import 'package:socale/state_machines/state_values/auth/auth_login_action_value.dart';

import '../../state_machines/state_values/auth/auth_state_value.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef ref;

  AuthState authState;
  AuthAction authAction;
  AuthLoginAction authLoginAction;

  AuthRouterDelegate(WidgetRef widgetRef)
      : navigatorKey = GlobalKey<NavigatorState>(),
        ref = widgetRef,
        authState = widgetRef.read(authStateProvider),
        authAction = widgetRef.read(authActionProvider),
        authLoginAction = widgetRef.read(authLoginActionProvider) {
    ref.listen(authStateProvider, updateAuthState);
    ref.listen(authActionProvider, updateAuthAction);
    ref.listen(authLoginActionProvider, updateAuthLoginAction);
  }

  void updateAuthState(oldState, newState) {
    authState = newState;
    notifyListeners();
  }

  void updateAuthAction(oldState, newState) {
    authAction = newState;
    notifyListeners();
  }

  void updateAuthLoginAction(oldState, newState) {
    authLoginAction = newState;
    notifyListeners();
  }

  @override
  AuthRoutePath get currentConfiguration {
    return AuthRoutePath.getStarted();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: GetStartedScreen()),
        if (authAction == AuthAction.signIn) MaterialPage(child: LoginScreen()),
        if (authAction == AuthAction.signUp) MaterialPage(child: RegisterScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }
}
