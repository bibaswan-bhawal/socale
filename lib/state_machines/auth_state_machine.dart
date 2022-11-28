import 'package:socale/state_machines/states/auth_state.dart';
import 'package:socale/utils/routes.dart';

class AuthStateMachine {
  String? getStateAction(AuthState state) {
    if (state == AuthState.signedIn) {
      return Routes.onboarding;
    }

    if (state == AuthState.signedOut) {
      return Routes.getStarted;
    }

    return null;
  }
}
