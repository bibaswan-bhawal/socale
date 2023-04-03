import 'package:freezed_annotation/freezed_annotation.dart';

part 'minor.freezed.dart';

part 'minor.g.dart';

@freezed
class Minor with _$Minor implements Comparable<Minor> {
  const Minor._();

  const factory Minor({
    required String id,
    required String name,
  }) = _Minor;

  factory Minor.fromJson(Map<String, dynamic> json) => _$MinorFromJson(json);

  @override
  String toString() => name;

  @override
  int compareTo(Minor other) {
    return name.compareTo(other.name);
  }
}
