import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Color(0xff272636),
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
                title == '' ? "---": title,
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
              (desc == '' || desc == null) ? "---" : desc,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF86829D),
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final String text;
  final bool isDone;
  final Function removeToDo;

  TodoWidget({this.text, @required this.isDone, @required this.removeToDo});

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
        color: widget.isDone ? Color(0xff2c2b3d) : Color(0xff272636),
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