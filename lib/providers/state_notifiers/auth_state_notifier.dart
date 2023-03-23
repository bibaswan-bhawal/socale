import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/state/auth_state/auth_state.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';
import 'package:socale/utils/validators.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AutoDisposeStateNotifierProviderRef<AuthStateNotifier, AuthState> ref;
  final KeepAliveLink disposeLink;

  AuthStateNotifier(this.ref)
      : disposeLink = ref.keepAlive(),
        super(AuthState.initial());

  void setAuthStep({required AuthStepState newStep, AuthStepState? previousStep, String? email, String? password}) {
    assert(newStep == AuthStepState.verifyEmail
        ? email != null &&
            password != null &&
            Validators.validateEmail(email) == null &&
            Validators.validatePassword(password) == null
        : true);

    state = state.copyWith(
      step: newStep,
      previousStep: previousStep ?? state.step,
      email: email,
      password: password,
    );
  }

  void popState() {
    switch (state.step) {
      case AuthStepState.verifyEmail:
        state = state.copyWith(step: state.previousStep ?? AuthStepState.getStarted);
      case AuthStepState.forgotPassword:
        state = state.copyWith(step: AuthStepState.login, previousStep: AuthStepState.forgotPassword);
      case AuthStepState.getStarted:
      default:
        state = state.copyWith(step: AuthStepState.getStarted);
    }
  }

  disposeState() => disposeLink.close();
}
