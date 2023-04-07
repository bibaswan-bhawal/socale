import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/options/club/club.dart';
import 'package:socale/models/options/interest/interest.dart';
import 'package:socale/models/options/language/language.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/models/options/minor/minor.dart';

part 'onboarding_user.freezed.dart';

part 'onboarding_user.g.dart';

@freezed
class OnboardingUser with _$OnboardingUser {
  const OnboardingUser._();

  const factory OnboardingUser({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    College? college,
    String? collegeEmail,
    String? anonymousUsername,
    DateTime? graduationDate,
    DateTime? dateOfBirth,
    List<Major>? majors,
    List<Minor>? minors,
    List<Language>? languages,
    List<Interest>? interests,
    List<Club>? clubs,
    @Default(5) int numRegenLeft,
    @Default(false) bool isCollegeEmailVerified,
    @_ProfileConverter() Image? anonymousProfileImage,
  }) = _OnboardingUser;

  factory OnboardingUser.fromJson(Map<String, dynamic> json) => _$OnboardingUserFromJson(json);
}

class _ProfileConverter implements JsonConverter<Image, String> {
  const _ProfileConverter();

  @override
  Image fromJson(String json) => Image.network(json);

  @override
  String toJson(Image object) => (object.image as NetworkImage).url;
}
