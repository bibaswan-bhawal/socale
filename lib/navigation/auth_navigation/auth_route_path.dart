import 'package:socale/models/state/auth_state/auth_state.dart';
import 'package:socale/navigation/main_navigation/main_route_path.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';

class AuthRoutePath extends AppRoutePath {
  AuthState appState;

  AuthRoutePath.getStarted() : appState = const AuthState(step: AuthStepState.getStarted, previousStep: null);

  AuthRoutePath.signUp() : appState = const AuthState(step: AuthStepState.register, previousStep: AuthStepState.getStarted);

  AuthRoutePath.signIn() : appState = const AuthState(step: AuthStepState.login, previousStep: AuthStepState.getStarted);

  AuthRoutePath.verifyEmail(AuthStepState previousStep)
      : appState = AuthState(step: AuthStepState.verifyEmail, previousStep: previousStep);

  AuthRoutePath.forgotPassword()
      : appState = const AuthState(step: AuthStepState.forgotPassword, previousStep: AuthStepState.login);
}
