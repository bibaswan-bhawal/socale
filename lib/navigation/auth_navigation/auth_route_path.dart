import 'package:socale/models/state/auth_state.dart';
import 'package:socale/navigation/main_navigation/main_route_path.dart';
import 'package:socale/types/auth/auth_step.dart';

class AuthRoutePath extends AppRoutePath {
  AuthState appState;

  AuthRoutePath.getStarted() : appState = AuthState(step: AuthStep.getStarted, previousStep: null);

  AuthRoutePath.signUp() : appState = AuthState(step: AuthStep.register, previousStep: AuthStep.getStarted);

  AuthRoutePath.signIn() : appState = AuthState(step: AuthStep.login, previousStep: AuthStep.getStarted);

  AuthRoutePath.verifyEmail(AuthStep previousStep) : appState = AuthState(step: AuthStep.verifyEmail, previousStep: previousStep);

  AuthRoutePath.forgotPassword() : appState = AuthState(step: AuthStep.forgotPassword, previousStep: AuthStep.login);
}
