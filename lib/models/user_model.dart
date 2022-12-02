import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/state_machines/auth_state_machine.dart';
import 'package:socale/state_machines/state_values/auth_state_values.dart';
import 'package:socale/state_machines/state_values/onboarding_state_values.dart';

class UserModel {
  AuthStateValue authState;
  OnboardingStateValue onboardingState;

  late String email;
  late String firstName;
  late String lastName;
  late DateTime dateOfBirth;
  late DateTime dateOfGraduation;
  late List<String> majors;
  late List<String> minors;
  late String college;

  UserModel({
    required this.authState,
    required this.onboardingState,
  });

  void setAuthState<T>(AuthStateValue authState, BuildContext context, WidgetRef ref) {
    this.authState = authState;

    AuthStateMachine.authStateChanged(authState, ref, context);
  }
}
