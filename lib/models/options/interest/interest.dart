import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/options/categorical/categorical.dart';

part 'interest.freezed.dart';

part 'interest.g.dart';

@freezed
class Interest with _$Interest implements Categorical<Interest> {
  const Interest._();

  const factory Interest({
    required String id,
    required String name,
    required String category,
  }) = _Interest;

  factory Interest.fromJson(Map<String, dynamic> json) => _$InterestFromJson(json);

  @override
  int compareTo(Interest other) => name.compareTo(other.name);

  @override
  String getCategory() => category;

  @override
  String toString() => name;
}
