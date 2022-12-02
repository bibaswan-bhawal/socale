import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/routes.dart';
import 'package:socale/state_machines/state_values/auth_state_values.dart';

class AuthStateMachine {
  static void authStateChanged(AuthStateValue state, WidgetRef ref, BuildContext context) {
    if (state == AuthStateValue.userDoesNotExist) {
      return;
    }

    if (state == AuthStateValue.signedIn) {}

    if (state == AuthStateValue.signedOut) {}
  }

  String? getStateAction(AuthStateValue state) {
    if (state == AuthStateValue.signedIn) {
      return Routes.onboarding;
    }

    if (state == AuthStateValue.signedOut) {
      return Routes.getStarted;
    }

    return null;
  }
}
