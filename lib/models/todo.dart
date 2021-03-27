class Todo {
  final int? id;
  final int? taskId;
  final String? title;
  final String? description;
  final String? category;
  final int? priority;
  final String? reminder;
  final int? isDone;
  final String? doneDate;
  Todo({
    this.id,
    this.taskId,
    this.title,
    this.isDone,
    this.description,
    this.priority,
    this.category,
    this.reminder,
    this.doneDate,
  });

  Map<String, dynamic> toMap() {
    print('reminder: $reminder');
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
      'description': description,
      'priority': priority,
      'category': category,
      'reminder': reminder,
      'doneDate': doneDate,
    };
  }
}
