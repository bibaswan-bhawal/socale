import 'package:socale/models/college.dart';

class OnboardingUser {
  College? college;

  String? firstName;
  String? lastName;

  DateTime? dateOfBirth;
  DateTime? graduationDate;

  List<String>? majors;
  List<String>? minors;

  OnboardingUser();

  @override
  String toString() {
    return 'name: $firstName $lastName, '
        'college $college, '
        'dateOfBirth: ${dateOfBirth?.toLocal()}, '
        'grad date: ${graduationDate?.toLocal()}, '
        'Majors: $majors, '
        'Minors: $minors';
  }
}
