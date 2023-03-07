import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/onboarding_user.dart';

class OnboardingUserNotifier extends StateNotifier<OnboardingUser> {
  KeepAliveLink? disposeLink;

  AutoDisposeStateNotifierProviderRef ref;

  OnboardingUserNotifier(this.ref) : super(const OnboardingUser()) {
    disposeLink = ref.keepAlive();
  }

  setCollege({college}) => state = state.copyWith(college: college);

  setEmail({email}) => state = state.copyWith(email: email);

  setCollegeEmail({collegeEmail}) => state = state.copyWith(collegeEmail: collegeEmail);

  setFirstName({firstName}) => state = state.copyWith(firstName: firstName);

  setLastName({lastName}) => state = state.copyWith(lastName: lastName);

  setDateOfBirth({dateOfBirth}) => state = state.copyWith(dateOfBirth: dateOfBirth);

  setGraduationDate({graduationDate}) => state = state.copyWith(graduationDate: graduationDate);

  setMajors({majors}) => state = state.copyWith(majors: majors);

  setMinors({minors}) => state = state.copyWith(minors: minors);

  disposeState() {
    disposeLink?.close();
  }
}
