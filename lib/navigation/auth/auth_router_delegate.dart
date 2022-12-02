import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/screen_get_started.dart';
import 'package:socale/state_machines/states/auth_flow_state.dart';
import 'package:socale/state_machines/state_values/auth_flow_state_value.dart';
import 'package:socale/state_machines/states/auth_flow_state_machine.dart';

class AuthRouterDelegate extends RouterDelegate<AuthRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef ref;

  AuthFlowState authFlowState;

  AuthRouterDelegate(WidgetRef widgetRef)
      : navigatorKey = GlobalKey<NavigatorState>(),
        ref = widgetRef,
        authFlowState = widgetRef.read(authFlowStateProvider) {
    ref.listen(authFlowStateProvider, updateState);
  }

  void updateState(oldState, newState) {
    print(newState);
    authFlowState = newState;
    notifyListeners();
  }

  @override
  AuthRoutePath get currentConfiguration {
    switch (authFlowState.state) {
      case AuthFlowStateValue.getStarted:
        return AuthRoutePath.getStarted();
      case AuthFlowStateValue.signIn:
        return AuthRoutePath.signIn();
      case AuthFlowStateValue.signUp:
        return AuthRoutePath.signUp();
      case AuthFlowStateValue.verifyEmail:
        return AuthRoutePath.verifyEmail();
      case AuthFlowStateValue.forgotPassword:
        return AuthRoutePath.forgotPassword();
      default:
        return AuthRoutePath.unknown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: GetStartedScreen()),
        if (authFlowState.state == AuthFlowStateValue.signUp) MaterialPage(child: RegisterScreen()),
        if (authFlowState.state == AuthFlowStateValue.signIn) MaterialPage(child: LoginScreen())
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        ref.read(authFlowStateProvider.notifier).setAuthFlowStep(AuthFlowStateValue.getStarted);
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AuthRoutePath configuration) async {
    if (configuration.isUnknown) throw ("Unknown path");

    ref.read(authFlowStateProvider).updateState(configuration.authFlowStateValue);
    updateState(authFlowState, AuthFlowState(state: configuration.authFlowStateValue));
  }
}
