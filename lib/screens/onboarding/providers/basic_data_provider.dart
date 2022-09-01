import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class BasicDataController with ChangeNotifier {
  String firstName = "";
  String lastName = "";
  DateTime birthDate = DateTime(2000, 6, 15);
  DateTime gradDate = DateTime(2025, 6);

  BasicDataController();

  String get getFirstName => firstName;
  String get getLastName => lastName;
  DateTime get getBirthDate => birthDate;
  DateTime get getGradDate => gradDate;

  void setFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  void setBirthDate(DateTime value) {
    birthDate = value;
    notifyListeners();
  }

  void setGradDate(DateTime value) {
    gradDate = value;
    notifyListeners();
  }

  void saveData() {
    onboardingService.setBiographics(firstName, lastName, birthDate, gradDate);
  }
}

final basicDataProvider = ChangeNotifierProvider((ref) {
  return BasicDataController();
});
