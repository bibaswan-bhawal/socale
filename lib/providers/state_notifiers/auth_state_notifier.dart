import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState());

  void setAuthAction(AuthAction authAction) => state = state.updateState(authAction: authAction);
  void resetPassword(bool resetPassword) => state = state.updateState(resetPassword: resetPassword);
  void verifyEmail(bool verifyEmail) => state = state.updateState(notVerified: verifyEmail);
}
