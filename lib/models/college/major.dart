class Major extends Comparable<Major> {
  final String id;
  final String name;

  Major({required this.id, required this.name});

  factory Major.fromJson(Map<String, dynamic> json) {
    String id = json['id'].split(':').last;
    String name = json['name'];

    return Major(id: id, name: name);
  }

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(Major other) {
    return name.compareTo(other.name);
  }
}
