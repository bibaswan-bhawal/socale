import 'package:socale/types/auth/auth_step.dart';

class AuthState {
  final AuthStep _step;
  final AuthStep? _previousStep;

  final String? _email;
  final String? _password;

  AuthState({
    step = AuthStep.getStarted,
    previousStep,
    email,
    password,
  })  : _step = step,
        _previousStep = previousStep,
        _email = email,
        _password = password;

  get step => _step;
  get previousStep => _previousStep;
  get email => _email;
  get password => _password;

  AuthState updateState({required AuthStep newStep, AuthStep? previousStep, String? email, String? password}) {
    return AuthState(
      step: newStep,
      previousStep: previousStep ?? step,
      email: email,
      password: password,
    );
  }

  @override
  String toString() => 'AuthState(step: $_step, previousStep: $_previousStep, email: $_email, password: $_password)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          _step == other._step &&
          _previousStep == other._previousStep &&
          _email == other._email &&
          _password == other._password;

  @override
  int get hashCode => Object.hash(super.hashCode, _step, _previousStep, _email, _password);
}
