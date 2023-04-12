import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';

class OnboardingCompleteScreen extends ConsumerStatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  ConsumerState<OnboardingCompleteScreen> createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends ConsumerState<OnboardingCompleteScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> createUser() async {
    final onboardingService = ref.read(onboardingServiceProvider);

    try {
      await onboardingService.onboardUser();

      const snackBar = SnackBar(content: Text('User Created'));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return true;
    } catch (e) {
      if (kDebugMode) print('Error: $e');

      const snackBar = SnackBar(content: Text('Failed to create new user'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(onboardingUserProvider.notifier).setIsOnboardingComplete(false);

        return false;
      },
      child: Scaffold(
        body: AnimatedContainer(
          decoration: const BoxDecoration(
            gradient: AppColors.orangeGradient,
          ),
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
