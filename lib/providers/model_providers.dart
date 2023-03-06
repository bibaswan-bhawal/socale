import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/current_user.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/providers/model_notifiers/current_user_notifier.dart';
import 'package:socale/providers/model_notifiers/onboarding_user_notifier.dart';

final currentUserProvider = StateNotifierProvider.autoDispose<CurrentUserNotifier, CurrentUser>((ref) => CurrentUserNotifier(ref));
final onboardingUserProvider = StateNotifierProvider.autoDispose<OnboardingUserNotifier, OnboardingUser>((ref) => OnboardingUserNotifier(ref));
