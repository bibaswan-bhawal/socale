import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/state/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/pages/get_started_page.dart';
import 'package:socale/navigation/auth/pages/login_page.dart';
import 'package:socale/navigation/auth/pages/register_page.dart';
import 'package:socale/navigation/auth/pages/reset_password_page.dart';
import 'package:socale/navigation/auth/pages/verify_page.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_step.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AuthRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AuthState authState = AuthState();

  AutoDisposeProviderRef ref;

  AuthRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    authState = ref.read(authStateProvider);
  }

  void updateAuthState(AuthState? oldState, AuthState newState) {
    if (authState == newState) return;
    authState = newState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, updateAuthState);

    return Navigator(
      key: navigatorKey,
      pages: [
        const GetStartedPage(),
        if (authState.step == AuthStep.login) const LoginPage(),
        if (authState.step == AuthStep.forgotPassword) ...[
          const LoginPage(),
          const ResetPasswordPage(),
        ],
        if (authState.step == AuthStep.register) const RegisterPage(),
        if (authState.step == AuthStep.verifyEmail) ...[
          if (authState.previousStep == AuthStep.login) const LoginPage(),
          if (authState.previousStep == AuthStep.register) const RegisterPage(),
          const VerifyPage(),
        ],
      ],
      onPopPage: (route, result) {
        ref.read(authStateProvider.notifier).popState();
        return route.didPop(result);
      },
    );
  }

  // Update route path
  AuthRoutePath getNewRoutePath(AuthState state) {
    switch (state.step) {
      case AuthStep.getStarted:
        return AuthRoutePath.getStarted();
      case AuthStep.login:
        return AuthRoutePath.signIn();
      case AuthStep.forgotPassword:
        return AuthRoutePath.forgotPassword();
      case AuthStep.register:
        return AuthRoutePath.signUp();
      case AuthStep.verifyEmail:
        return AuthRoutePath.verifyEmail(state.previousStep);
      default:
        return AuthRoutePath.getStarted();
    }
  }

  // new route path requested
  void newRouteRequested(AuthRoutePath configuration) {
    AuthState state = configuration.appState;
    ref
        .read(authStateProvider.notifier)
        .setAuthStep(newStep: state.step, previousStep: state.previousStep);
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    return;
  }
}
