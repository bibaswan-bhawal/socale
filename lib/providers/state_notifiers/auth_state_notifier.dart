import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/state/auth_state/auth_state.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/utils/validators.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.initial());

  void setAuthStep({required AuthStep newStep, AuthStep? previousStep, String? email, String? password}) {
    AuthState newState;

    if (newStep == AuthStep.verifyEmail) {
      assert(email != null &&
          password != null &&
          Validators.validateEmail(email) == null &&
          Validators.validatePassword(password) == null);
    }

    newState = state.copyWith(step: newStep, previousStep: previousStep, email: email, password: password);

    if (newState == state) return;
    state = newState;
  }

  void popState() {
    AuthState currentState = state;

    switch (currentState.step) {
      case AuthStep.verifyEmail:
        state = state.copyWith(step: currentState.previousStep ?? AuthStep.getStarted);
        break;
      case AuthStep.forgotPassword:
        state = state.copyWith(step: AuthStep.login);
        break;
      case AuthStep.getStarted:
        break;
      default:
        state = state.copyWith(step: AuthStep.getStarted);
        break;
    }
  }
}
