import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/onboarding_service.dart';

class SituationalDataNotifier with ChangeNotifier {
  List<int> _questions = [50, 50, 50, 50, 50];

  SituationalDataNotifier() {
    onboardingService.getSituationalDecisions().then((value) => _questions = value ?? [50, 50, 50, 50, 50]);
  }

  List<int> get getQuestions => _questions;

  void setQuestionValue(int value, int question) {
    _questions[question] = value;
    notifyListeners();
  }

  void uploadQuestions() => onboardingService.setSituationalDecisions(_questions);
  void clearData() {
    _questions = [50, 50, 50, 50, 50];
    notifyListeners();
  }
}

final situationalQuestionsProvider = ChangeNotifierProvider((ref) => SituationalDataNotifier());
