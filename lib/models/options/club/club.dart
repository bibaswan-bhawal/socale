import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/options/categorical/categorical.dart';

part 'club.freezed.dart';

part 'club.g.dart';

@freezed
class Club with _$Club implements Categorical<Club> {
  const Club._();

  const factory Club({
    required String name,
    required String id,
    required String category,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  @override
  int compareTo(Club other) => name.compareTo(other.name);

  @override
  String getCategory() => category;

  @override
  String toString() => name;
}
