import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/options/club/club.dart';
import 'package:socale/models/options/interest/interest.dart';
import 'package:socale/models/options/language/language.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/models/options/minor/minor.dart';
import 'package:socale/models/user/onboarding_user/onboarding_user.dart';

class OnboardingUserNotifier extends StateNotifier<OnboardingUser> {
  final AutoDisposeStateNotifierProviderRef ref;
  final KeepAliveLink disposeLink;

  OnboardingUserNotifier(this.ref)
      : disposeLink = ref.keepAlive(),
        super(const OnboardingUser());

  setId(String? value) => state = state.copyWith(id: value);

  setCollege(College? value) => state = state.copyWith(college: value);

  setEmail(String? value) => state = state.copyWith(email: value);

  setCollegeEmail(String? value) => state = state.copyWith(collegeEmail: value);

  setFirstName(String? value) => state = state.copyWith(firstName: value);

  setLastName(String? value) => state = state.copyWith(lastName: value);

  setDateOfBirth(DateTime? value) => state = state.copyWith(dateOfBirth: value);

  setGraduationDate(DateTime? value) => state = state.copyWith(graduationDate: value);

  setMajors(List<Major>? value) => state = state.copyWith(majors: value);

  setMinors(List<Minor>? value) => state = state.copyWith(minors: value);

  setLanguages(List<Language>? value) => state = state.copyWith(languages: value);

  setInterests(List<Interest>? value) => state = state.copyWith(interests: value);

  setClubs(List<Club>? value) => state = state.copyWith(clubs: value);

  setAnonymousUsername(String? value) => state = state.copyWith(anonymousUsername: value);

  setAnonymousProfileImage(String? value) => state = state.copyWith(anonymousProfileImage: value);

  setIsCollegeEmailVerified(bool value) => state = state.copyWith(isCollegeEmailVerified: value);

  setIsOnboardingComplete(bool value) => state = state.copyWith(isOnboardingComplete: value);

  setNumRegenLeft(int value) => state = state.copyWith(numRegenLeft: value);

  disposeState() => disposeLink.close();
}
