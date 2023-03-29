import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'college.freezed.dart';

part 'college.g.dart';

@freezed
class College with _$College {
  const factory College({
    required String id,
    required String name,
    @JsonKey(name: 'short_name') required String shortName,
    @JsonKey(name: 'fun_fact') required String funFact,
    @JsonKey(name: 'community_name') required String communityName,
    @JsonKey(name: 'email_extension') required String emailExtension,
    @JsonKey(name: 'profile_url') @_ProfileConverter() required Image profileImage,
  }) = _College;

  factory College.fromJson(Map<String, dynamic> json) => _$CollegeFromJson(json);
}

class _ProfileConverter implements JsonConverter<Image, String> {
  const _ProfileConverter();

  @override
  Image fromJson(String json) => Image.network(json);

  @override
  String toJson(Image object) => (object.image as NetworkImage).url;
}
