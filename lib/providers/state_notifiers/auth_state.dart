import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/types/auth/auth_action.dart';

class AuthState {
  final AuthAction authAction;
  final bool resetPassword;
  final bool notVerified;

  AuthState({
    this.authAction = AuthAction.noAction,
    this.resetPassword = false,
    this.notVerified = false,
  });

  AuthState updateState({AuthAction? authAction, bool? resetPassword, bool? notVerified}) {
    return AuthState(
      authAction: authAction ?? this.authAction,
      resetPassword: resetPassword ?? this.resetPassword,
      notVerified: notVerified ?? this.notVerified,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState());

  void setAuthAction(AuthAction authAction) => state = state.updateState(authAction: authAction);
  void resetPassword(bool resetPassword) => state = state.updateState(resetPassword: resetPassword);
  void verifyEmail(bool verifyEmail) => state = state.updateState(notVerified: verifyEmail);
}
