import 'package:flutter/material.dart';

import './models/todo.dart';
import './database_helper.dart';
class TaskCardWidget extends StatefulWidget {
  final String title;
  final String desc;
  final int taskId;

  TaskCardWidget({this.title, this.desc, this.taskId});

  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  DatabaseHelper _dbHelper = new DatabaseHelper();

  Future<String> getToDos(id) async {
    List<Todo> toDos;
    int done = 0;
    await _dbHelper.getTodo(id).then((value) => toDos = value);

    if (toDos.length == 0) {
      return '0/0';
    } else {
      for (var i = 0; i < toDos.length; i++) {
        if (toDos[i].isDone == 1) {
          done += 1;
        }
      }
      return '$done/${toDos.length}';
    }
  }

  Color whichColor(String doneTasks) {
    if (doneTasks == '0/0') {
      return Color(0xfff6ca6c);
    }
    if (doneTasks.split('/')[0] == doneTasks.split('/')[1]) {
      return Colors.green[400];
    }
    return Color(0xaa53e4df);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Color(0xff262a34),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.topic),
              SizedBox(width: 20),
              Text(
                widget.title == '' ? "---": widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Text(
              (widget.desc == '' || widget.desc == null) ? "---" : widget.desc,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF86829D),
                height: 1.5,
              ),
            ),
          ),
          FutureBuilder(
            future: getToDos(this.widget.taskId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 7),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whichColor(snapshot.data.toString())
                  ),
                  child: Text(snapshot.data.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                );
              } else {
                return Text('0/0', style: TextStyle(fontWeight: FontWeight.bold));
              }
            },
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final String text;
  final String description;
  final bool isDone;
  final Function removeToDo;
  final String reminder;

  TodoWidget({this.text, @required this.isDone, @required this.removeToDo, this.description, this.reminder});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.isDone ? Color(0xbb262a34) : Color(0xff262a34),
      ),
      child: ListTile(
        leading: Icon(Icons.check),
        title: Text(
          widget.text ?? "---",
          style: TextStyle(
            color: !widget.isDone ? Colors.white : Color(0xFF86829D),
            fontSize: 16.0,
            fontWeight: !widget.isDone ? FontWeight.bold : FontWeight.w500,
            decoration: widget.isDone ? TextDecoration.lineThrough : null
          ),
        ),
        subtitle: widget.description != null ? Text(widget.description, style: TextStyle(
          fontWeight: !widget.isDone ? FontWeight.bold : FontWeight.w500,
          decoration: widget.isDone ? TextDecoration.lineThrough : null
        )) : null,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.removeToDo,
        ),
        onLongPress: () => showDialog(context: context, builder: (context) => AlertDialog(content: Text('widget.reminder: ${widget.reminder}'),)),
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}