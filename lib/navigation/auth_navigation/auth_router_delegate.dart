import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth_navigation/auth_route_path.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_step.dart';
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
      case AuthStep.login:
        pages.add(const LoginPage());
      case AuthStep.forgotPassword:
        pages.add(const LoginPage());
        pages.add(const ResetPasswordPage());
      case AuthStep.register:
        pages.add(const RegisterPage());
      case AuthStep.verifyEmail:
        if (authState.previousStep == AuthStep.login) {
          pages.add(const LoginPage());
        } else if (authState.previousStep == AuthStep.register) {
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
