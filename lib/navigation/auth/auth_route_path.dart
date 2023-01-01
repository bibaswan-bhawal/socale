import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/state_notifiers/auth_state.dart';
import 'package:socale/types/auth/auth_action.dart';

class AuthRoutePath extends AppRoutePath {
  AuthState appState;

  AuthRoutePath.getStarted() : appState = AuthState();
  AuthRoutePath.signUp() : appState = AuthState(authAction: AuthAction.signUp);
  AuthRoutePath.signIn() : appState = AuthState(authAction: AuthAction.signIn);
  AuthRoutePath.verifyEmail(authAction) : appState = AuthState(authAction: authAction, notVerified: true);
  AuthRoutePath.forgotPassword() : appState = AuthState(authAction: AuthAction.signIn, resetPassword: true);
}
