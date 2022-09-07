import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class DescribeFriendDataNotifier with ChangeNotifier {
  String _description = "";

  bool _gotData = false;

  DescribeFriendDataNotifier() {
    onboardingService.getFriendDescription().then((value) {
      _description = value ?? "";
      _gotData = true;
      print(_gotData);
      notifyListeners();
    });
  }

  bool get getGotData => _gotData;

  String get getDescription => _description;

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void uploadFriendDescription() => onboardingService.setIdealFriendDescription(_description);
}

final describeFriendDataProvider = ChangeNotifierProvider((ref) => DescribeFriendDataNotifier());
