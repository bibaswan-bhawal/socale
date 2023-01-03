import 'package:socale/types/auth/auth_action.dart';

class AuthState {
  final AuthAction _authAction;
  final bool _resetPassword;
  final bool _notVerified;

  AuthState({
    authAction = AuthAction.noAction,
    resetPassword = false,
    notVerified = false,
  })  : _authAction = authAction,
        _resetPassword = resetPassword,
        _notVerified = notVerified;

  get authAction => _authAction;
  get resetPassword => _resetPassword && _authAction == AuthAction.signIn;
  get notVerified => _notVerified;

  AuthState updateState({AuthAction? authAction, bool? resetPassword, bool? notVerified}) {
    return AuthState(
      authAction: authAction ?? this.authAction,
      resetPassword: resetPassword ?? this.resetPassword,
      notVerified: notVerified ?? this.notVerified,
    );
  }

  @override
  String toString() => '\t\tAuthState:\n\t\t\t\tauthAction: $_authAction\n\t\t\t\tresetPassword: $_resetPassword\n\t\t\t\tnotVerified: $_notVerified';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          _authAction == other._authAction &&
          _resetPassword == other._resetPassword &&
          _notVerified == other._notVerified;

  @override
  int get hashCode => Object.hash(super.hashCode, _authAction, _notVerified, _resetPassword);
}
