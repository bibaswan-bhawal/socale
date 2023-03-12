import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/major/major.dart';
import 'package:socale/models/minor/minor.dart';

part 'onboarding_options_data.freezed.dart';

part 'onboarding_options_data.g.dart';

@freezed
class OnboardingOptionsData with _$OnboardingOptionsData {
  const OnboardingOptionsData._();

  const factory OnboardingOptionsData({
    College? college,
    @Default([]) List<Major> majors,
    @Default([]) List<Minor> minors,
  }) = _OnboardingOptionsData;

  factory OnboardingOptionsData.fromJson(Map<String, dynamic> json) => _$OnboardingOptionsDataFromJson(json);
}
