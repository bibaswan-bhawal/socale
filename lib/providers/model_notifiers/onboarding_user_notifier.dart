import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';
import 'package:socale/models/user/onboarding_user/onboarding_user.dart';

class OnboardingUserNotifier extends StateNotifier<OnboardingUser> {
  KeepAliveLink? disposeLink;

  AutoDisposeStateNotifierProviderRef ref;

  OnboardingUserNotifier(this.ref) : super(const OnboardingUser()) {
    disposeLink = ref.keepAlive();
    if (kDebugMode) print('Creating onboarding model');
  }

  setId(String? id) => state = state.copyWith(id: id);

  setCollege(College? college) => state = state.copyWith(college: college);

  setEmail(String? email) => state = state.copyWith(email: email);

  setCollegeEmail(String? collegeEmail) => state = state.copyWith(collegeEmail: collegeEmail);

  setFirstName(String? firstName) => state = state.copyWith(firstName: firstName);

  setLastName(String? lastName) => state = state.copyWith(lastName: lastName);

  setDateOfBirth(DateTime? dateOfBirth) => state = state.copyWith(dateOfBirth: dateOfBirth);

  setGraduationDate(DateTime? graduationDate) => state = state.copyWith(graduationDate: graduationDate);

  setMajors(List<Major>? majors) => state = state.copyWith(majors: majors);

  setMinors(List<Minor>? minors) => state = state.copyWith(minors: minors);

  setIsCollegeEmailVerified(bool isCollegeEmailVerified) =>
      state = state.copyWith(isCollegeEmailVerified: isCollegeEmailVerified);

  @override
  dispose() {
    super.dispose();
    if (kDebugMode) print('Destroying onboarding model');
  }

  disposeState() => disposeLink?.close();
}
