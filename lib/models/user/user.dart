import 'package:flutter/foundation.dart';

@immutable
class User {
  final String? _email;
  final String? _firstName;
  final String? _lastName;

  const User({String? email, String? firstName, String? lastName})
      : _email = email,
        _firstName = firstName,
        _lastName = lastName;

  String get email => _email ?? '';

  String get firstName => _firstName ?? '';

  String get lastName => _lastName ?? '';

  String get name => '$firstName  $lastName';

  User setEmail(value) => copyWith(email: value);

  User setFirstName(value) => copyWith(email: value);

  User setLastName(value) => copyWith(email: value);

  User copyWith({String? email, String? firstName, String? lastName}) {
    return User(
      email: email ?? _email,
      firstName: firstName ?? _firstName,
      lastName: lastName ?? _lastName,
    );
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'email: $email';
  }
}
