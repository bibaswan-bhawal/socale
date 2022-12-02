import 'package:socale/state_machines/state_values/auth_state_values.dart';
import 'package:socale/state_machines/states/auth_flow_state.dart';

class AuthState {
  final AuthStateValue authState;

  AuthState({this.authState = AuthStateValue.uninitialized});

  AuthState updateState(AuthStateValue authState) {
    return AuthState(authState: authState);
  }

  @override
  String toString() {
    return "Current AuthState: $authState";
  }
}
