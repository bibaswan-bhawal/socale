import 'package:socale/types/auth/state/auth_step_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required AuthStepState step,
    AuthStepState? previousStep,
    String? email,
    String? password,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(step: AuthStepState.getStarted);
}
