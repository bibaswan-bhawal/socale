import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class BasicDataController with ChangeNotifier {
  String _firstName = "";
  String _lastName = "";
  DateTime _birthDate = DateTime(2000, 6, 15);
  DateTime _gradDate = DateTime(2025, 6);

  bool _gotData = false;

  BasicDataController() {
    onboardingService.getBio().then((value) {
      if (value == null) {
        _gotData = true;
        notifyListeners();
        return;
      }

      _firstName = value[0] ?? "";
      _lastName = value[1] ?? "";
      _birthDate = value[2] ?? DateTime(2000, 6, 15);
      _gradDate = value[3] ?? DateTime(2025, 6);
      _gotData = true;
      notifyListeners();
    });
  }

  String get getFirstName => _firstName;
  String get getLastName => _lastName;
  DateTime get getBirthDate => _birthDate;
  DateTime get getGradDate => _gradDate;
  bool get getGotData => _gotData;

  void setFirstName(String value) {
    print(value);
    _firstName = value.trim();
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value.trim();
    notifyListeners();
  }

  void setBirthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  void setGradDate(DateTime value) {
    _gradDate = value;
    notifyListeners();
  }

  void uploadData() {
    onboardingService.setBio(
        _firstName.trim(), _lastName.trim(), _birthDate, _gradDate);
  }

  void clearData() {
    _firstName = "";
    _lastName = "";
    _birthDate = DateTime(2000, 6, 15);
    _gradDate = DateTime(2025, 6);
    notifyListeners();
  }
}

final basicDataProvider = ChangeNotifierProvider((ref) {
  return BasicDataController();
});
