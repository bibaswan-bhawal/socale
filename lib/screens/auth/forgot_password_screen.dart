import 'package:flutter/material.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LightOnboardingBackground(),
        ],
      ),
    );
  }
}
