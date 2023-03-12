import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'minor.freezed.dart';

part 'minor.g.dart';

@freezed
class Minor with _$Minor {
  const factory Minor({
    required String id,
    required String name,
  }) = _Minor;

  factory Minor.fromJson(Map<String, dynamic> json) => _$MinorFromJson(json);
}
