import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/pages/login_material_page.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/providers/state_notifiers/auth_state.dart';
import 'package:socale/screens/auth/forgot_password_screen.dart';
import 'package:socale/screens/auth/get_started_screen.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';
import 'package:socale/types/auth/auth_action.dart';

class AuthRouterDelegate extends RouterDelegate<AppRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AuthState authState;

  WidgetRef ref;

  String email;
  String password;

  AuthRouterDelegate(this.ref)
      : navigatorKey = GlobalKey<NavigatorState>(),
        authState = ref.read(authStateProvider),
        email = "",
        password = "" {
    ref.listen(authStateProvider, updateAuthState);
  }

  void updateAuthState(_, newState) {
    authState = newState;
    notifyListeners();
  }

  void updateEmail(String email) {
    this.email = email;
  }

  void updatePassword(String password) {
    this.password = password;
  }

  List<Page> pagesBuilder() {
    List<Page> pages = [];

    pages.add(
      MaterialPage(
        child: GetStartedScreen(),
      ),
    );

    switch (authState.authAction) {
      case AuthAction.signIn:
        pages.add(
          LoginMaterialPage(
            child: LoginScreen(
              updateEmail: updateEmail,
              updatePassword: updatePassword,
            ),
          ),
        );
        if (authState.resetPassword) {
          pages.add(
            MaterialPage(
              child: ForgotPasswordScreen(),
            ),
          );
        }
        break;
      case AuthAction.signUp:
        pages.add(
          MaterialPage(
            child: RegisterScreen(
              updateEmail: updateEmail,
              updatePassword: updatePassword,
            ),
          ),
        );
        break;
      default:
        break;
    }

    if (authState.notVerified) {
      pages.add(
        MaterialPage(
          child: VerifyEmailScreen(email: email, password: password),
        ),
      );
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: DefaultTransitionDelegate(),
      pages: pagesBuilder(),
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

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    return;
  }
}
