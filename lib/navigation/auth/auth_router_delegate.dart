import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/pages/register_page.dart';
import 'package:socale/navigation/auth/pages/reset_password_page.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/screens/auth/forgot_password_screen.dart';
import 'package:socale/screens/auth/get_started_screen.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/navigation/auth/pages/get_started_page.dart';
import 'package:socale/navigation/auth/pages/login_page.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AuthRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AuthState authState = AuthState();
  ProviderRef ref;

  AuthRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    authState = ref.read(authStateProvider);
    ref.listen(authStateProvider, updateAuthState);
  }

  void updateAuthState(AuthState? oldState, AuthState newState) {
    if (authState == newState) return;
    authState = newState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LightOnboardingBackground(),
        Navigator(
          key: navigatorKey,
          pages: [
            const GetStartedPage(key: ValueKey('get_started_page'), child: GetStartedScreen()),
            if (authState.authAction == AuthAction.signIn) ...[
              const LoginPage(key: ValueKey('login_page'), child: LoginScreen()),
              if (authState.resetPassword) const ResetPasswordPage(key: ValueKey('reset_password_page'), child: ForgotPasswordScreen()),
            ],
            if (authState.authAction == AuthAction.signUp) const RegisterPage(key: ValueKey('register_page'), child: LoginScreen()),
          ],
          onPopPage: (route, result) {
            if (authState.notVerified) {
              ref.read(authStateProvider.notifier).verifyEmail(false);
            } else if (authState.resetPassword) {
              ref.read(authStateProvider.notifier).resetPassword(false);
            } else {
              ref.read(authStateProvider.notifier).setAuthAction(AuthAction.noAction);
            }

            return route.didPop(result);
          },
        ),
      ],
    );
  }

  // Update route path
  AuthRoutePath getNewRoutePath(AuthState state) {
    if (state.notVerified) return AuthRoutePath.verifyEmail(state.authAction);
    if (state.resetPassword) return AuthRoutePath.forgotPassword();

    switch (state.authAction) {
      case AuthAction.noAction:
        return AuthRoutePath.getStarted();
      case AuthAction.signIn:
        return AuthRoutePath.signIn();
      case AuthAction.signUp:
        return AuthRoutePath.signUp();
    }

    return AuthRoutePath.getStarted();
  }

  // new route path requested
  void newRouteRequested(AuthRoutePath configuration) {
    AuthState state = configuration.appState;
    ref.read(authStateProvider.notifier).setAuthAction(state.authAction);
    ref.read(authStateProvider.notifier).resetPassword(state.resetPassword);
    ref.read(authStateProvider.notifier).verifyEmail(false);
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    return;
  }
}
