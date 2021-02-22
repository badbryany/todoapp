import 'package:requests/requests.dart';

import './models/task.dart';
import './models/todo.dart';

class Server {
  void newTask(Task task, int taskId) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/insertTask',
      json: {
        'id': taskId,
        'title': task.toMap()['title'],
        'description': task.toMap()['description']
      }
    );
    print(res.content());
  }

  void updateTaskTitle(int id, String title) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/updateTask',
      json: {
        'id': id,
        'newTitle': title,
      }
    );
    print(res.content());
  }

  void updateTaskDescription(int id, String description) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/updateTask',
      json: {
        'id': id,
        'newDescription': description,
      }
    );
    print(res.content());
  }

  void removeTask(int id) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/removeTask',
      json: {
        'user_task_id': id,
      }
    );
    print(res.content());
  }

  void addToDo(Todo todo, todoId) async {
    var todoData = todo.toMap();
    var res = await Requests.post(
      'http://10.0.0.129:3000/insertToDo',
      json: {
        'todo_id': todoId,
        'user_task_id': todoData['taskId'],
        'title': todoData['title'],
        'description': todoData['description'],
        'reminder': todoData['reminder'],
        'priority': todoData['priority'],
        'category': todoData['category'],
        'place': todoData['place'],
      }
    );
    print(res.content());
  }

  void updateToDo(Todo todo) async {
    var todoData = todo.toMap();
    var res = await Requests.post(
      'http://10.0.0.129:3000/updateToDo',
      json: {
        'todo_id': todoData['id'],
        'user_task_id': todoData['taskId'],
        'title': todoData['title'],
        'description': todoData['description'],
        'reminder': todoData['reminder'],
        'priority': todoData['priority'],
        'category': todoData['category'],
        'place': todoData['place'],
      }
    );
    print(res.content());
  }

  void updateToDoDone(int id, int isDone) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/updateToDoDone',
      json: {
        'todo_id': id,
        'isDone': isDone,
      }
    );
    print(res.content());
  }

  void removeToDo(int id) async {
    var res = await Requests.post(
      'http://10.0.0.129:3000/removeToDo',
      json: {
        'todo_id': id,
      }
    );
    print(res.content());
  }
}