class Todo {
  final int id;
  final int taskId;
  final String title;
  final String description;
  final int isDone;
  Todo({this.id, this.taskId, this.title, this.isDone, this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
      'description': description,
    };
  }
}