class Minor extends Comparable<Minor> {
  final String id;
  final String name;

  Minor({required this.id, required this.name});

  factory Minor.fromJson(Map<String, dynamic> json) {
    String id = json['id'].split(':').last;
    String name = json['name'];

    return Minor(id: id, name: name);
  }

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(Minor other) {
    return name.compareTo(other.name);
  }
}
