import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth_navigation/auth_route_path.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/navigation/auth_navigation/pages/auth_pages.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AuthRoutePath> {
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
        break;
      case AuthStep.forgotPassword:
        pages.add(const LoginPage());
        pages.add(const ResetPasswordPage());
        break;
      case AuthStep.register:
        pages.add(const RegisterPage());
        break;
      case AuthStep.verifyEmail:
        switch (authState.previousStep) {
          case AuthStep.login:
            pages.add(const LoginPage());
            break;
          case AuthStep.register:
            pages.add(const RegisterPage());
            break;
        }

        pages.add(const VerifyPage());
        break;
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
