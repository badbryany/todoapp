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

  double whichWidth(String doneTasks) {
    if (doneTasks.split('/')[0] == '0') {
      return 0;
    }
    return (100 / int.parse(doneTasks.split('/')[1])) * int.parse(doneTasks.split('/')[0]);
    /*if (doneTasks == '0/0') {
      return 0;
    }
    if (doneTasks.split('/')[0] == doneTasks.split('/')[1]) { // 4 == 4
      return 100;
    }*/
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 13),
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Color(0xff363748),
                              borderRadius: BorderRadius.circular(40)
                            ),
                          ),
                          Container(
                            width: whichWidth(snapshot.data.toString()),
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xff63f1b3), Color(0xffb8ffe5)]
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            child: SizedBox(width: 20)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 13),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(snapshot.data.toString(), style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                  ],
                );
              } else {
                return SizedBox(height: 45);
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
  final int priority;

  TodoWidget({this.text, @required this.isDone, @required this.removeToDo, this.description, this.reminder, this.priority});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget>{

  List<Widget> widgets() {
    if (widget.priority != null) {
      return [
        SizedBox(width: 10),
        Icon(
          Icons.priority_high_rounded,
          size: 20,
          color: widget.priority == 100 ? Colors.red : Colors.red.withOpacity(double.parse('0.${widget.priority}')),
        ),
      ];
    } else {
      return [];
    }
  }

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
        title: Row(
          children: [
            Text(
              widget.text ?? "---",
              style: TextStyle(
                color: !widget.isDone ? Colors.white : Color(0xFF86829D),
                fontSize: 16.0,
                fontWeight: !widget.isDone ? FontWeight.bold : FontWeight.w500,
                decoration: widget.isDone ? TextDecoration.lineThrough : null
              ),
            ),
            ...widgets(),
          ],
        ),
        subtitle: widget.description != null ? Text(widget.description, style: TextStyle(
          fontWeight: !widget.isDone ? FontWeight.bold : FontWeight.w500,
          decoration: widget.isDone ? TextDecoration.lineThrough : null
        )) : null,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.removeToDo,
        ),
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