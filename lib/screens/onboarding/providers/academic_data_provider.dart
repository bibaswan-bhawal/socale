import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class AcademicDataNotifier with ChangeNotifier {
  int _currentPage = 0;
  List<String> _majors = [];
  List<String> _minors = [];
  String _college = "";

  AcademicDataNotifier() {
    onboardingService.getCollegeInfo().then((value) {
      if (value == null) return;

      _majors = value[0] ?? [];
      _minors = value[1] ?? [];
      _college = value[2] ?? "";
      notifyListeners();
    });
  }

  int get getPage => _currentPage;
  List<String> get getMajors => _majors;
  List<String> get getMinors => _minors;
  String get getCollege => _college;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setMajors(List<String> values) {
    _majors = values;
    notifyListeners();
  }

  void setMinors(List<String> values) {
    _minors = values;
    notifyListeners();
  }

  void setCollege(String value) {
    _college = value;
    notifyListeners();
  }

  void uploadData() {
    onboardingService.setCollegeInfo(_majors, _minors, _college);
  }

  void clearData() {
    _currentPage = 0;
    _majors = [];
    _minors = [];
    _college = "";
    notifyListeners();
  }
}

final academicDataProvider = ChangeNotifierProvider((ref) => AcademicDataNotifier());
