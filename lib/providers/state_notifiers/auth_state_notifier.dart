import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/types/auth/auth_step.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState());

  @override
  void dispose() {
    super.dispose();
    print('Auth Provider Disposed');
  }

  void setAuthStep(AuthStep newStep, AuthStep? previousStep) =>
      state = state.updateState(newStep: newStep, previousStep: previousStep);
}
