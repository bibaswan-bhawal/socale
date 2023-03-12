// class College {
//   final String id;
//   final String name;
//   final String emailExtension;
//
//   const College({required this.id, required this.name, required this.emailExtension});
//
//   factory College.fromJson(Map<String, dynamic> json) {
//     String id = json['id']
//         .split(':')
//         .last;
//     String name = json['name'];
//     String emailExtension = json['email_extension'];
//
//     return College(id: id, name: name, emailExtension: emailExtension);
//   }
//
//   @override
//   String toString() {
//     return 'id: $id, name: $name, email suffix: $emailExtension';
//   }
// }

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'college.freezed.dart';

part 'college.g.dart';

@freezed
class College with _$College {
  const factory College({
    required String id,
    required String name,
    required String emailExtension,
  }) = _College;

  factory College.fromJson(Map<String, dynamic> json) => _$CollegeFromJson(json);
}
