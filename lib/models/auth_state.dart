import 'package:socale/types/auth/auth_step.dart';

class AuthState {
  final AuthStep _step;
  final AuthStep? _previousStep;

  AuthState({
    step = AuthStep.getStarted,
    previousStep,
  })  : _step = step,
        _previousStep = previousStep;

  get step => _step;
  get previousStep => _previousStep;

  AuthState updateState({required AuthStep newStep, AuthStep? previousStep}) {
    return AuthState(step: newStep, previousStep: previousStep ?? _step);
  }

  @override
  String toString() => 'AuthState(step: $_step, previousStep: $_previousStep)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          _step == other._step &&
          _previousStep == other._previousStep;

  @override
  int get hashCode => Object.hash(super.hashCode, _step, _previousStep);
}
