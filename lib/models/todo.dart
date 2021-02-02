class Todo {
  final int id;
  final int taskId;
  final String title;
  final String description;
  final String category;
  final int priority;
  final int isDone;
  Todo({this.id, this.taskId, this.title, this.isDone, this.description, this.priority, this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
      'description': description,
      'priority': priority,
      'category': category,
    };
  }
}