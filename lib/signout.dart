import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/services/onboarding_service.dart';

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onboardingService.clearAll();
          AuthRepository().signOutCurrentUser();
          Get.offAllNamed('/get_started');
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
