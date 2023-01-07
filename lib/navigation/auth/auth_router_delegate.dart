import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/pages/get_started_page.dart';
import 'package:socale/navigation/auth/pages/login_page.dart';
import 'package:socale/navigation/auth/pages/register_page.dart';
import 'package:socale/navigation/auth/pages/reset_password_page.dart';
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

    return Stack(
      children: [
        const LightOnboardingBackground(),
        Navigator(
          key: navigatorKey,
          pages: [
            const GetStartedPage(),
            if (authState.step == AuthStep.login) const LoginPage(),
            if (authState.step == AuthStep.forgotPassword) ...[
              const LoginPage(),
              const ResetPasswordPage(),
            ],
            if (authState.step == AuthStep.register) const RegisterPage(),
          ],
          onPopPage: (route, result) {
            switch (authState.step) {
              case AuthStep.forgotPassword:
                ref
                    .read(authStateProvider.notifier)
                    .setAuthStep(AuthStep.login, AuthStep.forgotPassword);
                break;
              case AuthStep.verifyEmail:
                ref
                    .read(authStateProvider.notifier)
                    .setAuthStep(ref.read(authStateProvider).previousStep, AuthStep.verifyEmail);
                break;
              case AuthStep.register:
                ref
                    .read(authStateProvider.notifier)
                    .setAuthStep(AuthStep.getStarted, AuthStep.register);
                break;
              case AuthStep.login:
                ref
                    .read(authStateProvider.notifier)
                    .setAuthStep(AuthStep.getStarted, AuthStep.login);
                break;
            }

            return route.didPop(result);
          },
        ),
      ],
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
    ref.read(authStateProvider.notifier).setAuthStep(state.step, state.previousStep);
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    return;
  }
}
