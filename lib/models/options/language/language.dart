import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';

part 'language.g.dart';

@freezed
class Language with _$Language implements Comparable<Language> {
  const Language._();

  const factory Language({
    required String id,
    required String name,
  }) = _Languages;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  @override
  String toString() => name;

  @override
  int compareTo(Language other) {
    return name.compareTo(other.name);
  }
}
