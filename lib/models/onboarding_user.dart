class OnboardingUser {
  String? firstName;
  String? lastName;

  DateTime? dateOfBirth;
  DateTime? graduationDate;

  List<String>? majors;
  List<String>? minors;

  int _currentStep = 0;

  int get currentStep => _currentStep;

  nextStep() {
    _currentStep = currentStep + 1;
  }

  previousStep() {
    _currentStep = currentStep - 1;
  }

  OnboardingUser();
}
