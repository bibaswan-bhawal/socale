import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/data_model.dart';

part 'major.freezed.dart';

part 'major.g.dart';

@freezed
class Major with _$Major implements DataModel<Major> {
  const Major._();

  const factory Major({
    required String id,
    required String name,
  }) = _Major;

  factory Major.fromJson(Map<String, dynamic> json) => _$MajorFromJson(json);

  @override
  String toString() => name;

  @override
  int compareTo(Major other) {
    return name.compareTo(other.name);
  }
}
