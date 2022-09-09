import 'package:flutter/material.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onboardingService.clearAll();
          authService.signOutCurrentUser();
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
