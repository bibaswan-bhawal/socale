import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'major.freezed.dart';

part 'major.g.dart';

@freezed
class Major with _$Major {
  const factory Major({
    required String id,
    required String name,
  }) = _Major;

  factory Major.fromJson(Map<String, dynamic> json) => _$MajorFromJson(json);
}
