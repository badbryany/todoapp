class Task {
  final int? id;
  final String title;
  final String description;
  final String owner;
  Task({
    this.id,
    required this.title,
    required this.description,
    required this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'title': title,
      'description': description,
      //'date': date,
    };
  }
}
