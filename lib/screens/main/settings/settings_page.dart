import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/services/onboarding_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onboardingService.clearAll();
          authRepository.signOutCurrentUser();
          Get.offAllNamed('/auth');
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
