import 'package:flutter/material.dart';
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
    @JsonKey(name: 'community_name') required String communityName,
    @JsonKey(name: 'short_name') required String shortName,
    @JsonKey(name: 'fun_facts') List<String>? funFacts,
    @JsonKey(name: 'profile_url') @ImageConverter() Image? profileImage,
  }) = _College;

  factory College.fromJson(Map<String, dynamic> json) => _$CollegeFromJson(json);
}

class ImageConverter implements JsonConverter<Image?, String> {
  const ImageConverter();

  @override
  Image? fromJson(String json) => Image.network(json);

  @override
  String toJson(Image? object) => (object?.image as NetworkImage).url;
}
