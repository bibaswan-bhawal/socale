import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onboardingService.clearAll();
          authService.signOutCurrentUser();
          Get.offAllNamed('/auth');
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
