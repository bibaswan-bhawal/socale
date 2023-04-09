import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/options/club/club.dart';
import 'package:socale/models/options/interest/interest.dart';
import 'package:socale/models/options/language/language.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/models/options/minor/minor.dart';

part 'onboarding_user.freezed.dart';

part 'onboarding_user.g.dart';

@Freezed(toJson: false)
class OnboardingUser with _$OnboardingUser {
  const OnboardingUser._();

  const factory OnboardingUser({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    College? college,
    String? collegeEmail,
    String? anonymousProfileImage,
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
    @Default(false) bool isOnboardingComplete,
  }) = _OnboardingUser;

  factory OnboardingUser.fromJson(Map<String, dynamic> json) => _$OnboardingUserFromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'collegeEmail': collegeEmail,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': '${dateOfBirth?.toString()}Z',
        'graduationDate': '${graduationDate?.toString()}Z',
        'anonymousProfileImage': anonymousProfileImage,
        'anonymousUsername': anonymousUsername,
        'majors': majors?.map((major) => major.id).toList() ?? [],
        'minors': minors?.map((minor) => minor.id).toList() ?? [],
        'languages': languages?.map((language) => language.id).toList() ?? [],
        'interests': interests?.map((interest) => interest.id).toList() ?? [],
        'clubs': clubs?.map((club) => club.id).toList() ?? [],
      };
}
