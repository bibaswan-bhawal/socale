import 'package:flutter/material.dart';
export 'package:socale/transitions/slide_horizontal_transition.dart';
export 'package:flutter/material.dart';

abstract class BaseOnboardingPage extends Page {
  const BaseOnboardingPage({super.key});

  get child;
}
