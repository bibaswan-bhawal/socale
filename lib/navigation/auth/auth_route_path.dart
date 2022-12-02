import 'package:socale/state_machines/state_values/auth_flow_state_value.dart';

class AuthRoutePath {
  AuthFlowStateValue authFlowStateValue;
  bool isUnknown;

  AuthRoutePath.getStarted()
      : authFlowStateValue = AuthFlowStateValue.getStarted,
        isUnknown = false;
  AuthRoutePath.signUp()
      : authFlowStateValue = AuthFlowStateValue.signUp,
        isUnknown = false;
  AuthRoutePath.signIn()
      : authFlowStateValue = AuthFlowStateValue.signIn,
        isUnknown = false;
  AuthRoutePath.verifyEmail()
      : authFlowStateValue = AuthFlowStateValue.verifyEmail,
        isUnknown = false;
  AuthRoutePath.forgotPassword()
      : authFlowStateValue = AuthFlowStateValue.forgotPassword,
        isUnknown = false;
  AuthRoutePath.unknown()
      : authFlowStateValue = AuthFlowStateValue.getStarted,
        isUnknown = true;
}
