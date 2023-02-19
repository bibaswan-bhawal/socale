class User {
  String? _email;
  String? _firstName;
  String? _lastName;

  User();

  String get email => _email!;
  String get firstName => _firstName!;
  String get lastName => _lastName!;
  String get name => '$_firstName  $lastName';

  set email(String email) => _email = email;
  set firstName(String firstName) => _firstName = firstName;
  set lastName(String lastName) => _lastName = lastName;
}
