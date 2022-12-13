import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_login_action.dart';

class AuthRoutePath {
  bool isUnknown;
  AuthAction authAction;
  AuthLoginAction authLoginAction;

  AuthRoutePath.getStarted()
      : isUnknown = false,
        authLoginAction = AuthLoginAction.noAction,
        authAction = AuthAction.noAction;
  AuthRoutePath.signUp()
      : isUnknown = false,
        authLoginAction = AuthLoginAction.noAction,
        authAction = AuthAction.signUp;
  AuthRoutePath.signIn()
      : isUnknown = false,
        authLoginAction = AuthLoginAction.noAction,
        authAction = AuthAction.signIn;
  AuthRoutePath.verifyEmail()
      : isUnknown = false,
        authLoginAction = AuthLoginAction.noAction,
        authAction = AuthAction.noAction;
  AuthRoutePath.forgotPassword()
      : isUnknown = false,
        authLoginAction = AuthLoginAction.forgotPassword,
        authAction = AuthAction.signIn;
}
