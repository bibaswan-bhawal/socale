import 'package:socale/types/auth/auth_step.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStep step,
    AuthStep? previousStep,
    String? email,
    String? password,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(step: AuthStep.getStarted);
}
