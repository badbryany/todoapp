import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../database_helper.dart';
import './taskpage.dart';
import '../widgets.dart';
import '../models/task.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  final List<Color> colors = [
    Color(0xff050609),
    Color(0xff131129),
    Color(0xff874FD0)
  ];

  Future notificationSelected(String payload) async {
    _dbHelper.getTasks().then((e) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Taskpage(
            task: e[int.parse(payload)-1],
            notificationSelected: notificationSelected,
          ),
        ),
      ).then(
        (value) {
          setState(() {});
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          //margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          //color: Color(0xff1f1d2b),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors[1],
                colors[0],
                colors[1],
              ],
              stops: [0, 0.8, 1],
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/logo.png', width: 35),
                        SizedBox(width: 30),
                        Text('Aufgaben', style: TextStyle(fontSize: 23),),
                      ],
                    ),
                    SizedBox()
                    //SvgPicture.asset('assets/icons/avatar.svg', width: 35)
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ScrollConfiguration(
                      behavior: NoGlowBehaviour(),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          ...snapshot.data.map((e) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Taskpage(
                                        task: e,
                                        notificationSelected: notificationSelected,
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                onLongPress: () async {
                                  await _dbHelper.deleteTask(e.id);
                                  setState(() {
                                    _dbHelper.getTasks();
                                  });
                                },
                                child: TaskCardWidget(
                                  taskId: e.id,
                                  title: e.title,
                                  desc: e.description,
                                ),
                              );
                            }
                          ), // map
                          InkWell(
                            onTap: () async {
                              Task _newTask = Task(title: '', description: '');
                              var _taskId = await _dbHelper.insertTask(_newTask);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Taskpage(
                                    task: Task(id: _taskId, title: '', description: ''),
                                    notificationSelected: notificationSelected,
                                  )),
                              ).then((value) => setState(() {}));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 32,
                                horizontal: 24,
                              ),
                              //margin: EdgeInsets.only(bottom: 20.0,),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xffc197fb), Color(0xff806ff2)]
                                ),
                                color: Color(0xff806ff2),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Icon(Icons.add)
                            ),
                          ),
                        ],
                      ),
                    );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}