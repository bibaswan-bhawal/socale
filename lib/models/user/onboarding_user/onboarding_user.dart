import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';

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
    @_ProfileConverter() Image? anonymousProfileImage,
    DateTime? graduationDate,
    DateTime? dateOfBirth,
    List<Major>? majors,
    List<Minor>? minors,
    @Default(false) bool isCollegeEmailVerified,
    @Default(5) int numRegenLeft,
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
