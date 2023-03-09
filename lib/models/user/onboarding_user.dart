import 'package:flutter/material.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/models/college/major.dart';
import 'package:socale/models/college/minor.dart';

@immutable
class OnboardingUser {
  final College? college;

  final String? email;
  final String? collegeEmail;

  final String? firstName;
  final String? lastName;

  final DateTime? dateOfBirth;
  final DateTime? graduationDate;

  final List<Major>? majors;
  final List<Minor>? minors;

  const OnboardingUser({
    this.college,
    this.email,
    this.collegeEmail,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.graduationDate,
    this.majors,
    this.minors,
  });

  copyWith({
    String? email,
    College? college,
    String? collegeEmail,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    DateTime? graduationDate,
    List<Major>? majors,
    List<Minor>? minors,
  }) {
    return OnboardingUser(
      college: college ?? this.college,
      email: email ?? this.email,
      collegeEmail: collegeEmail ?? this.collegeEmail,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      graduationDate: graduationDate ?? this.graduationDate,
      majors: majors ?? this.majors,
      minors: minors ?? this.minors,
    );
  }

  @override
  String toString() {
    return 'name: $firstName $lastName\n'
        'college $college\n'
        'college Email: $collegeEmail\n'
        'dateOfBirth: ${dateOfBirth?.toLocal()}\n'
        'grad date: ${graduationDate?.toLocal()}\n'
        'Majors: $majors\n'
        'Minors: $minors';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingUser &&
          runtimeType == other.runtimeType &&
          college == other.college &&
          email == other.email &&
          collegeEmail == other.collegeEmail &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          dateOfBirth == other.dateOfBirth &&
          graduationDate == other.graduationDate &&
          majors == other.majors &&
          minors == other.minors;

  @override
  int get hashCode =>
      college.hashCode ^
      email.hashCode ^
      collegeEmail.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      dateOfBirth.hashCode ^
      graduationDate.hashCode ^
      majors.hashCode ^
      minors.hashCode;
}
