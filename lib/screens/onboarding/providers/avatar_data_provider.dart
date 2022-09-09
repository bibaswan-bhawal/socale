import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/options/avatars.dart';

class AvatarDataNotifier with ChangeNotifier {
  int _currentAvatar = 0;

  AvatarDataNotifier() {
    _currentAvatar = avatars.indexOf(onboardingService.getAvatar() ?? 'Artist Raccoon.png');
  }

  int get getCurrentAvatar => _currentAvatar;

  void setCurrentAvatar(int value) {
    _currentAvatar = value;
    notifyListeners();
  }

  void uploadData() {
    onboardingService.setAvatar(avatars[_currentAvatar]);
  }
}

final avatarDataProvider = ChangeNotifierProvider((ref) => AvatarDataNotifier());
