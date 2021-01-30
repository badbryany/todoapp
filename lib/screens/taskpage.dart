import 'package:flutter/material.dart';
import 'dart:ui';
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

class _TaskpageState extends State<Taskpage>{
  DatabaseHelper _dbHelper = DatabaseHelper();
  final key = GlobalKey<AnimatedListState>();

  String todoTitle = '';
  String todoDescription = '';

  Widget blure = SizedBox();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  DateTime _dateTime;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;
  bool _addToDo = false;
  double _addHeight = 150;
  bool _description = false;

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

  Future<DateTime> pickDate() async {
    DateTime _dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(3000),
    );
    var _time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1),
    );
    print('_time: $_time; _dateTime: $_dateTime;');
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> toDoSettings = [
      {'icon': Icon(Icons.subject, size: 30, color: Color(0xffbf96fa)), 'onTap': () => setState(() {_description = true; _addHeight = 200;})},
      {'icon': Icon(Icons.alarm, color: Color(0xffbf96fa), size: 30), 'onTap': pickDate},
      //{'icon': Icon(Icons.tune, color: Color(0xffbf96fa), size: 30), 'onTap': () {print('foo');}},
    ];
    return Scaffold(
      body: Container(
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
                                description: snapshot.data[index].description,
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
                    onPressed: () => setState(() {
                      _addToDo = !_addToDo;
                      blure = InkWell(
                        onTap: () => setState(() {blure = SizedBox(); _addToDo = false; _description = false;}),
                        child: Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 1,
                            sigmaY: 1,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                          ),
                        )
                      ),
                      );
                    }),
                  )
                )
              ),
              blure,
              //add ToDo
              Visibility(
                visible: _addToDo,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  height: _addHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff2e2e31),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: TextField(
                            autofocus: true,
                            focusNode: _todoFocus,
                            controller: TextEditingController()
                              ..text = '',
                            onSubmitted: (value) async {
                              // Check if the field is not empty
                              if (value != "") {
                                if (_taskId != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: _taskId,
                                    description: todoDescription
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {
                                    todoTitle = '';
                                    todoDescription = '';
                                    _description = false;
                                    _addToDo = false;
                                    blure = SizedBox();
                                  });
                                  //_todoFocus.requestFocus();
                                } else {
                                  print("Task doesn't exist");
                                }
                              }
                            },
                            onChanged: (value) => todoTitle = value,
                            decoration: InputDecoration(
                              hintText: "Neue Aufgabe...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _description,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()
                                ..text = '',
                              onChanged: (value) => todoDescription = value,
                              decoration: InputDecoration(
                                hintText: 'Details hinzufügen...',
                                hintStyle: TextStyle(fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  //{var color = '0xffffc548';},
                                  ...toDoSettings.map((e) => InkWell(
                                    onTap: e['onTap'],
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(7),
                                      child: e['icon'],
                                    ),
                                  )),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  String value = todoTitle;
                                  // Check if the field is not empty
                                  if (value != '') {
                                    if (_taskId != 0) {
                                      DatabaseHelper _dbHelper = DatabaseHelper();
                                      Todo _newTodo = Todo(
                                        title: value,
                                        isDone: 0,
                                        taskId: _taskId,
                                        description: todoDescription,
                                      );
                                      await _dbHelper.insertTodo(_newTodo);
                                      setState(() {
                                        todoTitle = '';
                                        todoDescription = '';
                                        _addToDo = false;
                                        _description = false;
                                        blure = SizedBox();
                                      });
                                      //_todoFocus.requestFocus();
                                    } else {
                                      print('Task doesn\'t exist');
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text('Speichern', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}