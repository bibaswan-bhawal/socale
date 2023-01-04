import 'package:socale/types/auth/auth_action.dart';

class AuthState {
  final AuthAction _authAction;
  final bool _resetPassword;
  final bool _notVerified;

  final AuthAction _previousAuthAction;

  AuthState({
    authAction = AuthAction.noAction,
    resetPassword = false,
    notVerified = false,
    previousAuthAction = AuthAction.noAction,
  })  : _authAction = authAction,
        _resetPassword = resetPassword,
        _notVerified = notVerified,
        _previousAuthAction = previousAuthAction;

  get authAction => _authAction;
  get resetPassword => _resetPassword && _authAction == AuthAction.signIn;
  get notVerified => _notVerified;
  get previousAuthAction => _previousAuthAction;

  AuthState updateState({AuthAction? authAction, bool? resetPassword, bool? notVerified}) {
    return AuthState(
      authAction: authAction ?? this.authAction,
      resetPassword: resetPassword ?? this.resetPassword,
      notVerified: notVerified ?? this.notVerified,
      previousAuthAction: authAction != null ? this.authAction : previousAuthAction,
    );
  }

  @override
  String toString() =>
      'AuthState(authAction: $authAction, resetPassword: $resetPassword, notVerified: $notVerified, previousAuthAction: $previousAuthAction)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          _authAction == other._authAction &&
          _resetPassword == other._resetPassword &&
          _notVerified == other._notVerified &&
          _previousAuthAction == other._previousAuthAction;

  @override
  int get hashCode => Object.hash(super.hashCode, _authAction, _notVerified, _resetPassword, _previousAuthAction);
}
