import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class PersonalityDataNotifier with ChangeNotifier {
  List<String> _skills = [];
  List<String> _academicInterests = [];
  List<String> _careerGoals = [];
  List<String> _selfDescription = [];
  List<String> _hobbies = [];

  bool _gotSkillData = false;
  bool _gotAcademicInterestsData = false;
  bool _gotCareerGoalsData = false;
  bool _gotSelfDescriptionData = false;
  bool _gotHobbies = false;

  PersonalityDataNotifier() {
    onboardingService.getSkills().then((value) {
      _skills = value ?? [];
      _gotSkillData = true;
      notifyListeners();
    });

    onboardingService.getAcademicInterests().then((value) {
      _academicInterests = value ?? [];
      _gotAcademicInterestsData = true;
      notifyListeners();
    });

    onboardingService.getCareerGoals().then((value) {
      _careerGoals = value ?? [];
      _gotCareerGoalsData = true;
      notifyListeners();
    });

    onboardingService.getSelfDescription().then((value) {
      _selfDescription = value ?? [];
      _gotSelfDescriptionData = true;
      notifyListeners();
    });

    onboardingService.getHobbies().then((value) {
      _hobbies = value ?? [];
      _gotHobbies = true;
      notifyListeners();
    });
  }

  bool get getGotSkillData => _gotSkillData;
  bool get getGotAcademicInterestsData => _gotAcademicInterestsData;
  bool get getGotCareerGoalsData => _gotCareerGoalsData;
  bool get getGotSelfDescriptionData => _gotSelfDescriptionData;
  bool get getGotHobbiesData => _gotHobbies;

  List<String> get getSkills => _skills;
  List<String> get getAcademicInterests => _academicInterests;
  List<String> get getCareerGoals => _careerGoals;
  List<String> get getSelfDescription => _selfDescription;
  List<String> get getHobbies => _hobbies;

  void setSkills(List<String> value) {
    _skills = value;
    notifyListeners();
  }

  void setAcademicInterests(List<String> value) {
    _academicInterests = value;
    notifyListeners();
  }

  void setCareerGoals(List<String> value) {
    _careerGoals = value;
    notifyListeners();
  }

  void setSelfDescription(List<String> value) {
    _selfDescription = value;
    notifyListeners();
  }

  void setHobbies(List<String> value) {
    _hobbies = value;
    notifyListeners();
  }

  void uploadSkills() => onboardingService.setSkills(_skills);
  void uploadAcademicInterests() => onboardingService.setAcademicInterests(_academicInterests);
  void uploadCareerGoals() => onboardingService.setCareerGoals(_careerGoals);
  void uploadSelfDescription() => onboardingService.setSelfDescription(_selfDescription);
  void uploadHobbies() => onboardingService.setLeisureInterests(_hobbies);
}

final personalityDataProvider = ChangeNotifierProvider((ref) => PersonalityDataNotifier());
