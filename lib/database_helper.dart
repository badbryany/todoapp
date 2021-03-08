import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

import './server.dart';

import "models/task.dart";
import "models/todo.dart";

class DatabaseHelper {
  Server server = new Server();

  Future<Database> database() async {
    String foo = (await getDatabasesPath()) as String;
    return openDatabase(
      join(foo, "todo.db"),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, description TEXT, priority INTEGER, reminder TEXT, category TEXT, place TEXT, isDone INTEGER)');

        //return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task, bool shouldSync) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert("tasks", task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });

    if (shouldSync) {
      server.newTask(task, taskId);
    }

    return taskId;
  }

  Future<void> updateTaskTitle(int? id, String title) async {
    Database _db = await database();
    await _db.rawUpdate('UPDATE tasks SET title="$title" WHERE id="$id"');
    server.updateTaskTitle(id, title);
  }

  Future<void> updateTaskDescription(int? id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        'UPDATE tasks SET description = "$description" WHERE id = "$id"');
    server.updateTaskDescription(id, description);
  }

  Future<void> insertTodo(Todo todo, bool shouldSync) async {
    Database _db = await database();
    int todoId = await _db.insert("todo", todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    if (shouldSync) {
      server.addToDo(todo, todoId);
    }
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query("tasks");

    var serverTasks = await server.getTasks();

    List<dynamic> newTaskMap =
        (await server.compareTasks(taskMap, serverTasks)) as List<dynamic>;

    return List.generate(newTaskMap.length, (index) {
      return Task(
          id: newTaskMap[index]["id"],
          title: newTaskMap[index]["title"],
          description: newTaskMap[index]["description"]);
    });
  }

  Future<List<Todo>> getTodo(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');

    server.getTaskTodos(taskId);

    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]["id"],
          title: todoMap[index]["title"],
          taskId: todoMap[index]["taskId"],
          isDone: todoMap[index]["isDone"],
          description: todoMap[index]["description"],
          priority: todoMap[index]["priority"],
          category: todoMap[index]["category"],
          reminder: todoMap[index]["reminder"]);
    });
  }

  Future<List<Todo>> getTodos() async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]["id"],
          title: todoMap[index]["title"],
          taskId: todoMap[index]["taskId"],
          isDone: todoMap[index]["isDone"],
          description: todoMap[index]["description"],
          priority: todoMap[index]["priority"],
          category: todoMap[index]["category"],
          reminder: todoMap[index]["reminder"]);
    });
  }

  Future<void> updateTodoDone(int? id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate('UPDATE todo SET isDone = "$isDone" WHERE id = "$id"');
    server.updateToDoDone(id, isDone);
  }

  Future<void> updateTodo(int? id, String? title, String? description,
      double priority, String? category, int? taskId) async {
    Database _db = await database();
    await _db.rawUpdate('UPDATE todo SET title="$title" WHERE id = "$id"');
    await _db.rawUpdate(
        'UPDATE todo SET description="$description" WHERE id = "$id"');
    await _db
        .rawUpdate('UPDATE todo SET priority="$priority" WHERE id = "$id"');
    await _db
        .rawUpdate('UPDATE todo SET category="$category" WHERE id = "$id"');
    Todo todo = new Todo(
        taskId: taskId,
        id: id,
        title: title,
        description: description,
        priority: priority.toInt(),
        category: category);
    server.updateToDo(todo);
  }

  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete('DELETE FROM tasks WHERE id = "$id"');
    await _db.rawDelete('DELETE FROM todo WHERE taskId = "$id"');
    server.removeTask(id);
  }

  Future<void> deleteToDo(int? id) async {
    Database _db = await database();
    await _db.rawDelete('DELETE FROM todo WHERE id = "$id"');
    server.removeToDo(id);
  }
}
