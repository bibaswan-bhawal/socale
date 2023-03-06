class College {
  final String id;
  final String name;
  final String emailExtension;

  const College({required this.id, required this.name, required this.emailExtension});

  factory College.fromJson(Map<String, dynamic> json) {
    return College(id: json['id'], name: json['name'], emailExtension: json['email_extension']);
  }

  @override
  String toString() {
    return 'id: $id, name: $name, email suffix: $emailExtension';
  }
}
