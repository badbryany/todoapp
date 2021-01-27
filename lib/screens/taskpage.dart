import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';
import '../widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;

  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final key = GlobalKey<AnimatedListState>();

  var _items;
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;
  bool _addToDo = false;

  @override
  void initState() {
    if (widget.task != null) {
      // Set visibility to true
      _contentVisile = true;

      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xff1f1d2b),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Icon(Icons.arrow_back)
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              _descriptionFocus.requestFocus();
                            },
                            onChanged: (value) async {
                              print(value + ', taskId: ${widget.task.id}');
                              value.length <= 7 ? await _dbHelper.updateTaskTitle(_taskId, value) : print('too long');
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Title der Liste",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value != '' && value.length <= 20){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        onChanged: (value) async {
                          if(value != '' && value.length <= 20){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                        },
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Gib eine Beschreibung der Liste ein...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _dbHelper.getTodo(_taskId),
                    builder: (context, snapshot) {
                      if (snapshot.data.length == 0) {
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/imgs/relax.svg', width: MediaQuery.of(context).size.width*0.6, alignment: Alignment.center,),
                                SizedBox(height: 20),
                                Text('Du hast alle Aufgaben erledigt!\nEntspann dich!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if(snapshot.data[index].isDone == 0){
                                  await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                } else {
                                  await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                }
                                setState(() {});
                              },
                              child: TodoWidget(
                                text: snapshot.data[index].title,
                                isDone: snapshot.data[index].isDone == 0 ? false : true,
                                removeToDo: () {
                                  _dbHelper.deleteToDo(snapshot.data[index].id);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                top: 35,
                right: 25,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {_addToDo = !_addToDo;}),
                  )
                )
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                //width: double.infinity, //MediaQuery.of(context).size.width
                child: Visibility(
                  visible: _addToDo,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      //color: Color(0xff272636),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Color(0xFF86829D), width: 1.5)),
                          child: SizedBox()
                        ),
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            focusNode: _todoFocus,
                            controller: TextEditingController()..text = "",
                            onSubmitted: (value) async {
                              // Check if the field is not empty
                              if (value != "") {
                                if (_taskId != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                      taskId: _taskId,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  _todoFocus.requestFocus();
                                } else {
                                  print("Task doesn't exist");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Neue Aufgabe...",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}