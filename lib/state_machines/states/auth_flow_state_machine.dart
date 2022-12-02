import 'package:flutter/material.dart';
import 'package:socale/screens/auth/login_screen.dart';
import 'package:socale/screens/auth/register_screen.dart';
import 'package:socale/screens/auth/screen_get_started.dart';
import 'package:socale/state_machines/state_values/auth_flow_state_value.dart';
import 'package:socale/state_machines/states/auth_flow_state.dart';

class AuthFlowStateMachine {
  static List<MaterialPage> getPages(AuthFlowState authFlowState) {
    List<MaterialPage> pages = [];

    pages.add(MaterialPage(child: GetStartedScreen()));
    if (authFlowState.state == AuthFlowStateValue.signIn) {
      pages.add(MaterialPage(child: LoginScreen()));
    } else if (authFlowState.state == AuthFlowStateValue.signUp) {
      pages.add(MaterialPage(child: RegisterScreen()));
    }

    return pages;
  }
}
