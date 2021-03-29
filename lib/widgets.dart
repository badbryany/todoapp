import 'package:flutter/material.dart';

import './models/todo.dart';
import 'global/database_helper.dart';

class TaskCardWidget extends StatefulWidget {
  final String? title;
  final String? desc;
  final int taskId;

  TaskCardWidget({this.title, this.desc, required this.taskId});

  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  DatabaseHelper _dbHelper = new DatabaseHelper();

  String todos = '';

  Future<String> getToDos(id) async {
    late List<Todo> toDos;
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

  double whichWidth(String doneTasks) {
    if (doneTasks.split('/')[0] == '0') {
      return 0;
    }
    return (100 / int.parse(doneTasks.split('/')[1])) *
        int.parse(doneTasks.split('/')[0]);
    /*if (doneTasks == '0/0') {
      return 0;
    }
    if (doneTasks.split('/')[0] == doneTasks.split('/')[1]) { // 4 == 4
      return 100;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    List colors = [
      Theme.of(context).canvasColor,
      Theme.of(context).focusColor,
      Theme.of(context).primaryColor,
      Theme.of(context).dividerColor,
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colors[widget.taskId % colors.length],
                    ),
                  ),
                  /*Icon(
                    Icons.topic,
                    color: colors[widget.taskId % 4],
                  ),*/
                  SizedBox(width: 20),
                  Text(
                    widget.title == '' ? "---" : widget.title!,
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
                  (widget.desc == '' || widget.desc == null)
                      ? "---"
                      : widget.desc!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
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
                                width: 200,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              Container(
                                width: whichWidth(snapshot.data.toString()) * 2,
                                height: 5,
                                decoration: BoxDecoration(
                                  /*gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xff63f1b3),
                                      Color(0xffb8ffe5)
                                    ],
                                  ),*/
                                  color: Color(0xff22cc62),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: SizedBox(width: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 13),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
          Container(
            margin: EdgeInsets.only(left: 50),
            child: FutureBuilder(
              future: getToDos(this.widget.taskId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).shadowColor,
                    ),
                    child: Center(
                      child: Text(
                        snapshot.data.toString().split('/')[1],
                        style: TextStyle(
                          color: colors[widget.taskId % 4],
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final String? text;
  final String? description;
  final bool isDone;
  final Function removeToDo;
  final String? reminder;
  final int? priority;

  final animation;

  TodoWidget({
    this.text,
    required this.isDone,
    required this.removeToDo,
    this.description,
    this.reminder,
    this.priority,
    this.animation,
  });

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  List<Widget> widgets() {
    if (widget.priority != null) {
      return [
        SizedBox(width: 10),
        Icon(
          Icons.priority_high_rounded,
          size: 20,
          color: widget.priority == 100
              ? Colors.red
              : Colors.red.withOpacity(double.parse('0.${widget.priority}')),
        ),
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation == null) {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: widget.isDone
              ? Theme.of(context).cardColor.withOpacity(0.5)
              : Theme.of(context).cardColor,
        ),
        child: ListTile(
          leading: Icon(Icons.check),
          title: Row(
            children: [
              Text(
                widget.text ?? "---",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight:
                      !widget.isDone ? FontWeight.bold : FontWeight.w500,
                  decoration: widget.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              ...widgets(),
            ],
          ),
          subtitle: widget.description != null
              ? Text(widget.description!,
                  style: TextStyle(
                      fontWeight:
                          !widget.isDone ? FontWeight.bold : FontWeight.w500,
                      decoration:
                          widget.isDone ? TextDecoration.lineThrough : null))
              : null,
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.removeToDo as void Function()?,
          ),
        ),
      );
    }
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: widget.animation,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: widget.isDone
              ? Theme.of(context).cardColor.withOpacity(0.5)
              : Theme.of(context).cardColor,
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
                  fontWeight:
                      !widget.isDone ? FontWeight.bold : FontWeight.w500,
                  decoration: widget.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              ...widgets(),
            ],
          ),
          subtitle: widget.description != null
              ? Text(widget.description!,
                  style: TextStyle(
                      fontWeight:
                          !widget.isDone ? FontWeight.bold : FontWeight.w500,
                      decoration:
                          widget.isDone ? TextDecoration.lineThrough : null))
              : null,
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.removeToDo as void Function()?,
          ),
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
