import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/state_machines/state_values/auth_flow_state_value.dart';

class AuthFlowState {
  final AuthFlowStateValue state;

  AuthFlowState({this.state = AuthFlowStateValue.getStarted});

  AuthFlowState updateState(AuthFlowStateValue newState) => AuthFlowState(state: newState);
  AuthFlowStateValue getState() => state;

  @override
  String toString() => "Current auth flow step: $state";
}

class AuthFlowStateNotifier extends StateNotifier<AuthFlowState> {
  AuthFlowStateNotifier() : super(AuthFlowState());

  void setAuthFlowStep(AuthFlowStateValue authFlowStateValue) => state = state.updateState(authFlowStateValue);
}
