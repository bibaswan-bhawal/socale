import 'package:flutter/material.dart';
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

  setLanguages(List<Language>? languages) => state = state.copyWith(languages: languages);

  setInterests(List<Interest>? interests) => state = state.copyWith(interests: interests);

  setClubs(List<Club>? clubs) => state = state.copyWith(clubs: clubs);

  setAnonymousUsername(String? anonymousUsername) => state = state.copyWith(anonymousUsername: anonymousUsername);

  setAnonymousProfileImage(String? anonymousProfileImage) => state = state.copyWith(
      anonymousProfileImage: anonymousProfileImage != null ? Image.network(anonymousProfileImage) : null);

  setIsCollegeEmailVerified(bool isCollegeEmailVerified) =>
      state = state.copyWith(isCollegeEmailVerified: isCollegeEmailVerified);

  setIsOnboardingComplete(bool isOnboardingComplete) =>
      state = state.copyWith(isOnboardingComplete: isOnboardingComplete);

  setNumRegenLeft(int numRegenLeft) => state = state.copyWith(numRegenLeft: numRegenLeft);

  disposeState() => disposeLink.close();
}
