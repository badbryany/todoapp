import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

import '../screens/homepage.dart';

import 'package:connectivity/connectivity.dart';

import 'database_helper.dart';

import '../models/task.dart';
import '../models/todo.dart';

class Server {
  final String url = 'http://10.0.0.101:3000';

  // general functions
  Future<bool> checkInternet(BuildContext context, bool changed) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                color: Colors.red[100],
              ),
              SizedBox(width: 10),
              Text(
                'du bist offline',
                style: TextStyle(color: Colors.red[100]),
              )
            ],
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      );
      return false;
    } else if (changed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_4_bar_rounded,
              color: Colors.green[200],
            ),
            SizedBox(width: 10),
            Text(
              'verbunden',
              style: TextStyle(color: Colors.green[200]),
            )
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).backgroundColor,
      ));
    }
    return true;
  }

  Future<List<dynamic>?> compareTasks(
      List<dynamic> taskMap, List<dynamic>? serverTasks) async {
    if (HomePage.loggedIn) {
      if (taskMap.length > serverTasks!.length ||
          taskMap.length == serverTasks.length) {
        // more Lists at the Client as at the Server
        int difference = taskMap.length - serverTasks.length;

        for (int i = 0; i < difference; i++) {
          Task _newTask = Task(
              id: taskMap[i + serverTasks.length]['id'],
              title: taskMap[i + serverTasks.length]['title'],
              description: taskMap[i + serverTasks.length]['description']);
          await this.newTask(_newTask, taskMap[i + serverTasks.length]['id']);

          serverTasks.add(taskMap[i + serverTasks.length]);
        }
        for (int j = 0; j < serverTasks.length; j++) {
          if (taskMap[j]['title'] != serverTasks[j]['title']) {
            this.updateTaskTitle(serverTasks[j]['id'], taskMap[j]['title']);
            serverTasks[j]['title'] = taskMap[j]['title'];
          }
          if (taskMap[j]['description'] != serverTasks[j]['description']) {
            this.updateTaskDescription(
                serverTasks[j]['id'], taskMap[j]['description']);
            serverTasks[j]['description'] = taskMap[j]['description'];
          }
        }
      }
      /* else if (serverTasks.length > taskMap.length) { // more Lists at the Server as at the Client
        int difference = serverTasks.length - taskMap.length;

        for (int i = 0; i < difference; i++) {
          taskMap.add(serverTasks[i + taskMap.length]);
        }
        for (int j = 0; j < serverTasks.length; j++) {
          if (serverTasks[j]['title'] != taskMap[j]['title']) {
            serverTasks[j].title = taskMap[j].title;
          }
          if (serverTasks[j]['description'] != taskMap[j]['description']) {
            this.updateTaskDescription(taskMap[j]['id'], serverTasks[j]['description']);
            serverTasks[j].description = taskMap[j].description;
          }
        }
      }*/
      DatabaseHelper _dbHelper = DatabaseHelper();

      for (int i = 0; i < serverTasks.length; i++) {
        Task _insertTask = Task(
          id: serverTasks[i]['id'],
          title: serverTasks[i]['title'],
          description: serverTasks[i]['description'],
        );
        await _dbHelper.insertTask(_insertTask, false);

        // get ToDos of the Task
        List<dynamic> serverToDos =
            (await this.getTaskTodos(serverTasks[i]['id']) as List<dynamic>);
        List<dynamic> clientToDos = await _dbHelper.getTodos();

        if (serverToDos.length <= clientToDos.length) {
          // more todos at the client
          for (int i = 0; i < clientToDos.length; i++) {
            this.addToDo(clientToDos[i], clientToDos[i].id);
          }
        } else {
          for (int i = 0; i < serverToDos.length; i++) {
            bool shouldInsert = true;
            for (int j = 0; j < clientToDos.length; j++) {
              if (clientToDos[j].id == serverToDos[i]['todo_id']) {
                shouldInsert = false;
              }
            }
            if (shouldInsert) {
              Todo _insertToDo = Todo(
                id: serverToDos[i]['todo_id'],
                taskId: serverToDos[i]['user_task_id'],
                title: serverToDos[i]['title'],
                description: serverToDos[i]['description'],
                category: serverToDos[i]['category'],
                isDone: serverToDos[i]['isDone'],
                priority: serverToDos[i]['priority'],
                reminder: serverToDos[i]['reminder'],
              );
              _dbHelper.insertTodo(_insertToDo, false);
            }
          }
        }
      }
      return serverTasks;
    }
    return taskMap;
  }

  // get all data from the server
  Future<List<dynamic>?> getTasks() async {
    if (HomePage.loggedIn) {
      var res = await Requests.get('${Server().url}/getTasks');
      if (res.content() != 'bad request' || res.content() != 'no session') {
        return jsonDecode(res.content());
      } else {
        return [];
      }
    }
  }

  Future<List<dynamic>?> getTaskTodos(int? taskId) async {
    if (HomePage.loggedIn) {
      var res = await Requests.get('$url/getTaskToDos',
          queryParameters: {'task_id': taskId});
      return jsonDecode(res.content());
    }
  }

  // backup all on the server
  newTask(Task task, int? taskId) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/insertTask', json: {
        'id': taskId,
        'title': task.toMap()['title'],
        'description': task.toMap()['description']
      });
      //print(res.content());
    }
  }

  updateTaskTitle(int? id, String? title) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/updateTask', json: {
        'id': id,
        'newTitle': title,
      });
      //print(res.content());
    }
  }

  updateTaskDescription(int? id, String? description) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/updateTask', json: {
        'id': id,
        'newDescription': description,
      });
      //print(res.content());
    }
  }

  removeTask(int? id) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/removeTask', json: {
        'user_task_id': id,
      });
      //print(res.content());
    }
  }

  addToDo(Todo todo, todoId) async {
    if (HomePage.loggedIn) {
      var todoData = todo.toMap();
      var res = await Requests.post('$url/insertToDo', json: {
        'todo_id': todoId,
        'user_task_id': todoData['taskId'],
        'title': todoData['title'],
        'description': todoData['description'],
        'reminder': todoData['reminder'],
        'priority': todoData['priority'],
        'category': todoData['category'],
        'place': todoData['place'],
      });
      //print(res.content());
    }
  }

  updateToDo(Todo todo) async {
    if (HomePage.loggedIn) {
      var todoData = todo.toMap();
      var res = await Requests.post('$url/updateToDo', json: {
        'todo_id': todoData['id'],
        'user_task_id': todoData['taskId'],
        'title': todoData['title'],
        'description': todoData['description'],
        'reminder': todoData['reminder'],
        'priority': todoData['priority'],
        'category': todoData['category'],
        'place': todoData['place'],
      });
      //print(res.content());
    }
  }

  updateToDoDone(int? id, int isDone) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/updateToDoDone', json: {
        'todo_id': id,
        'isDone': isDone,
      });
      //print(res.content());
    }
  }

  removeToDo(int? id) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/removeToDo', json: {
        'todo_id': id,
      });
      //print(res.content());
    }
  }

  //	----------------	FREINDS AND TODOS-LIST SYNCRONISATION	 ----------------	//

  Future<List> getPeople() async {
    if (HomePage.loggedIn) {
      var res = await Requests.get('$url/getPeople');
      return jsonDecode(res.content());
    }
    return [];
  }

  Future<List> getFriends() async {
    if (HomePage.loggedIn) {
      var res = await Requests.get('$url/getFriends');
      return jsonDecode(res.content());
    }
    return [];
  }

  void newFriend(String username) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post('$url/newFriend', json: {
        'newFriend': username,
      });
      print(res.content());
    }
  }

  Future<List> getReuests() async {
    if (HomePage.loggedIn) {
      var res = await Requests.get('$url/getRequests');
      return jsonDecode(res.content());
    }
    return [];
  }

  Future<void> acceptRequest(String name) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post(
        '$url/acceptFriend',
        json: {
          'friend': name,
        },
      );
      //print(res.content());
    }
  }

  Future<void> denyRequest(String name) async {
    if (HomePage.loggedIn) {
      var res = await Requests.post(
        '$url/denyFriend',
        json: {
          'friend': name,
        },
      );
      //print(res.content());
    }
  }
}
