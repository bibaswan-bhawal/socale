import 'package:freezed_annotation/freezed_annotation.dart';

part 'major.freezed.dart';

part 'major.g.dart';

@freezed
class Major with _$Major {
  const Major._();

  const factory Major({
    required String id,
    required String name,
  }) = _Major;

  factory Major.fromJson(Map<String, dynamic> json) => _$MajorFromJson(json);

  @override
  String toString() => name;

  int compareTo(Major other) {
    return name.compareTo(other.name);
  }
}