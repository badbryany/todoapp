import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animations/animations.dart';

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

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<dynamic> tasks = [];
  //int counter = 0;

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
            reloadTasks: getTasks,
          ),
        ),
      ).then(
        (value) {
          setState(() {});
        },
      )
    );
  }

  void _showDevInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 40,
          backgroundColor: Color(0xff262a34),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15,),
                    Text('Entwickler: Oskar Kellermann', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                    SizedBox(height: 15,),
                    //Text('Helfer: stackoverflow.com/', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network('https://www.flaticon.com/svg/vstatic/svg/25/25231.svg?token=exp=1612963422~hmac=dbf414c258db04df32a174a6389d431f', width: 30),
                        SizedBox(width: 20),
                        Text('badbryany', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network('https://upload.wikimedia.org/wikipedia/commons/e/ef/Stack_Overflow_icon.svg', width: 30),
                        SizedBox(width: 20),
                        Text('oskarkel', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network('https://www.clipartmax.com/png/full/169-1696957_instagram-icon-instagram-icon-svg-white.png', width: 30),
                        SizedBox(width: 20),
                        Text('ein.oskar', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                      ],
                    ),
                    SizedBox(height: 22,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [Color(0xff213BD0), Color(0xff2c46da)])),
                          child: Text('ok'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Icon(Icons.person, color: Colors.white)
                ),
              ),
            ],
          )
        );
      }
    );
  }

  Future<void> getTasks() async {
    tasks = [];
    var _tasks = await _dbHelper.getTasks();

    for (int i = 0; i < _tasks.length; i++) {
      listKey.currentState.insertItem(i);
      tasks.add(_tasks[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
   getTasks();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                        InkWell(
                          onTap: _showDevInfo,
                          child: Image.asset('assets/icons/logo.png', width: 35)
                        ),
                        SizedBox(width: 30),
                        Text('Aufgaben', style: TextStyle(fontSize: 23),),
                      ],
                    ),
                    SizedBox(),
                    InkWell(
                      onTap: () async {
                        Task _newTask = Task(title: '', description: '');
                        await _dbHelper.insertTask(_newTask);
                        print(tasks.length);
                        listKey.currentState.insertItem(tasks.length);
                        tasks.insert(tasks.length, _newTask);

                        getTasks();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.add)
                      )
                    ),
                    SvgPicture.asset('assets/icons/avatar.svg', width: 35)
                  ],
                ),
              ),
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: tasks.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= tasks.length) {
                      print('how is that possibile???!!!');
                      return SizedBox();
                    } else {
                      return SizeTransition(
                        axis: Axis.vertical,
                        sizeFactor: animation,
                        child: OpenContainer(
                          closedColor: colors[1].withOpacity(0.1),
                          openColor: Colors.transparent.withOpacity(0),
                          transitionDuration: Duration(milliseconds: 500),
                          openBuilder: (_, closeContainer) {
                            return Taskpage(
                              task: Task(id: tasks[index].id, title: tasks[index].title, description: tasks[index].description),
                              notificationSelected: notificationSelected,
                              reloadTasks: getTasks
                            );
                          },
                          closedBuilder: (_, openContainer) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onLongPress: () async {
                                  listKey.currentState.removeItem(index, (context, animation) {
                                    return SizeTransition(
                                      axis: Axis.vertical,
                                      sizeFactor: animation,
                                      child: TaskCardWidget(taskId: tasks[index].id,title: tasks[index].title,desc: tasks[index].description,)
                                    );
                                  },);

                                  _dbHelper.deleteTask(tasks[index].id);
                                  tasks.removeAt(index);
                                },
                                onTap: openContainer,
                                child: TaskCardWidget(
                                  taskId: tasks[index].id,
                                  title: tasks[index].title,
                                  desc: tasks[index].description,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}