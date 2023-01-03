import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/pages/fade_out_page.dart';
import 'package:socale/navigation/pages/slide_transition_page.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/screens/auth/forgot_password_screen.dart';
import 'package:socale/screens/auth/get_started_screen.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';
import 'package:socale/types/auth/auth_action.dart';

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
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeOutPage(child: const GetStartedScreen()),
        if (authState.authAction == AuthAction.signIn) ...[
          SlideTransitionPage(child: const LoginScreen(), transitionType: SharedAxisTransitionType.horizontal),
          if (authState.resetPassword) const MaterialPage(child: ForgotPasswordScreen()),
        ],
        if (authState.authAction == AuthAction.signUp) const MaterialPage(child: RegisterScreen()),
        if (authState.notVerified) const MaterialPage(child: VerifyEmailScreen()),
      ],
      onPopPage: (route, result) {
        if (authState.notVerified) {
          ref.read(authStateProvider.notifier).verifyEmail(false);
          return route.didPop(result);
        }

        if (authState.resetPassword) {
          ref.read(authStateProvider.notifier).resetPassword(false);
          return route.didPop(result);
        }

        switch (authState.authAction) {
          case AuthAction.noAction:
            return true;
          default:
            ref.read(authStateProvider.notifier).setAuthAction(AuthAction.noAction);
            return route.didPop(result);
        }
      },
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
