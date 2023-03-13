import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'college.freezed.dart';

part 'college.g.dart';

@freezed
class College with _$College {
  const factory College({
    required String id,
    required String name,
    @JsonKey(name: 'email_extension') required String emailExtension,
  }) = _College;

  factory College.fromJson(Map<String, dynamic> json) => _$CollegeFromJson(json);
}
