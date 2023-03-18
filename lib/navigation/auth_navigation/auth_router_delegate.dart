import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth_navigation/auth_route_path.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';
import 'package:socale/navigation/auth_navigation/pages/auth_pages.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AuthRoutePath> {
  AutoDisposeChangeNotifierProviderRef ref;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AuthRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>();

  void updateDelegate(_, __) => notifyListeners();

  List<Page> buildPages() {
    final authState = ref.read(authStateProvider);

    final List<Page> pages = [];

    pages.add(const GetStartedPage());

    switch (authState.step) {
      case AuthStepState.login:
        pages.add(const LoginPage());
      case AuthStepState.forgotPassword:
        pages.add(const LoginPage());
        pages.add(const ResetPasswordPage());
      case AuthStepState.register:
        pages.add(const RegisterPage());
      case AuthStepState.verifyEmail:
        if (authState.previousStep == AuthStepState.login) {
          pages.add(const LoginPage());
        } else if (authState.previousStep == AuthStepState.register) {
          pages.add(const RegisterPage());
        }
        pages.add(const VerifyPage());
      default:
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, updateDelegate);

    return Navigator(
      key: navigatorKey,
      pages: buildPages(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        ref.read(authStateProvider.notifier).popState();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    return;
  }
}
