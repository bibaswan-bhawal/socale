import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/forgot_password_screen.dart';
import 'package:socale/screens/auth/get_started_screen.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_login_action.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef ref;

  AuthAction authAction;
  AuthLoginAction authLoginAction;

  String email;
  String password;

  AuthRouterDelegate(WidgetRef widgetRef)
      : navigatorKey = GlobalKey<NavigatorState>(),
        ref = widgetRef,
        authAction = widgetRef.read(authActionProvider),
        email = "",
        password = "",
        authLoginAction = widgetRef.read(authLoginActionProvider) {
    ref.listen(authActionProvider, updateAuthAction);
    ref.listen(authLoginActionProvider, updateAuthLoginAction);
  }

  void updateAuthLoginAction(_, newState) {
    authLoginAction = newState;
    notifyListeners();
  }

  void updateAuthAction(_, newState) {
    authAction = newState;
    notifyListeners();
  }

  void updateEmail(String email) {
    this.email = email;
  }

  void updatePassword(String password) {
    this.password = password;
  }

  @override
  AuthRoutePath get currentConfiguration {
    if (authLoginAction == AuthLoginAction.forgotPassword) {
      return AuthRoutePath.forgotPassword();
    }

    switch (authAction) {
      case AuthAction.signIn:
        return AuthRoutePath.signIn();
      case AuthAction.signUp:
        return AuthRoutePath.signUp();
      case AuthAction.verify:
        return AuthRoutePath.verifyEmail();
      case AuthAction.noAction:
        return AuthRoutePath.getStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: GetStartedScreen(),
        ),
        if (authAction == AuthAction.signIn)
          MaterialPage(
            child: LoginScreen(
              updateEmail: updateEmail,
              updatePassword: updatePassword,
            ),
          ),
        if (authAction == AuthAction.signUp)
          MaterialPage(
            child: RegisterScreen(),
          ),
        if (authLoginAction == AuthLoginAction.forgotPassword)
          MaterialPage(
            child: ForgotPasswordScreen(),
          ),
        if (authAction == AuthAction.verify)
          MaterialPage(
            child: VerifyEmailScreen(
              email: email,
              password: password,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        if (authLoginAction == AuthLoginAction.forgotPassword) {
          ref.read(authLoginActionProvider.notifier).state = AuthLoginAction.noAction;
          return true;
        }

        switch (authAction) {
          case AuthAction.verify:
            email = "";
            password = "";
            ref.read(authActionProvider.notifier).state = AuthAction.noAction;
            break;
          default:
            ref.read(authActionProvider.notifier).state = AuthAction.noAction;
            break;
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    if (configuration.authLoginAction == AuthLoginAction.forgotPassword) {
      ref.read(authLoginActionProvider.notifier).state = AuthLoginAction.forgotPassword;
      ref.read(authActionProvider.notifier).state = AuthAction.signIn;
      return;
    }

    switch (configuration.authAction) {
      case AuthAction.noAction:
        ref.read(authActionProvider.notifier).state = AuthAction.noAction;
        break;
      case AuthAction.signIn:
        ref.read(authActionProvider.notifier).state = AuthAction.signIn;
        break;
      case AuthAction.signUp:
        ref.read(authActionProvider.notifier).state = AuthAction.signUp;
        break;
      case AuthAction.verify:
        ref.read(authActionProvider.notifier).state = AuthAction.verify;
    }
    return;
  }
}
