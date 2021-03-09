import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database_helper.dart';
import './taskpage.dart';
import '../widgets.dart';
import '../models/task.dart';
import './profile.dart';
import './loginpage.dart';

import 'package:connectivity/connectivity.dart';

import '../global/server.dart';

class HomePage extends StatefulWidget {
  static bool loggedIn = false;
  static bool connection = false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<dynamic> tasks = [];

  final List<Color> colors = [
    Color(0xff050609),
    Color(0xff131129),
    Color(0xff874FD0)
  ];

  final Connectivity _connectivity = Connectivity();
  var foo;

  void initState() {
    super.initState();
    foo = _connectivity.onConnectivityChanged.listen((change) async {
      bool _connection = await Server().checkInternet(context, true);
      setState(() {
        HomePage.connection = _connection;
        _connection == false ? HomePage.loggedIn = false : null;
      });
      if (HomePage.connection) {
        SharedPreferences.getInstance().then((instance) async {
          String username = instance.getString('username');
          String password = instance.getString('password');

          if (username != null && password != null) {
            await LoginPage.login(username, password).then((r) {
              HomePage.loggedIn = r;
            });
          } else {
            print('no data to login');
          }
        });
      }
    });

    Server().checkInternet(context, false).then((r) {
      HomePage.connection = r;
      if (HomePage.connection) {
        SharedPreferences.getInstance().then((instance) async {
          String username = instance.getString('username');
          String password = instance.getString('password');

          if (username != null && password != null) {
            await LoginPage.login(username, password).then((r) {
              HomePage.loggedIn = r;
            });
          } else {
            print('no data to login');
          }
          getTasks(true);
        });
      } else {
        print('no connection to the internet!');
        getTasks(true);
      }
    });
  }

  void dispose() {
    foo.cancel();
    super.dispose();
  }

  Future notificationSelected(String payload) async {
    _dbHelper.getTasks().then((e) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Taskpage(
              task: e[int.parse(payload) - 1],
              notificationSelected: notificationSelected,
              reloadTasks: getTasks,
              closeContainer: () => print('bug'),
            ),
          ),
        ).then(
          (value) {
            setState(() {});
          },
        ));
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
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Entwickler: Oskar Kellermann',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                                'https://www.flaticon.com/svg/vstatic/svg/25/25231.svg?token=exp=1612963422~hmac=dbf414c258db04df32a174a6389d431f',
                                width: 30),
                            SizedBox(width: 20),
                            Text(
                              'badbryany',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                                'https://upload.wikimedia.org/wikipedia/commons/e/ef/Stack_Overflow_icon.svg',
                                width: 30),
                            SizedBox(width: 20),
                            Text(
                              'oskarkel',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                                'https://www.clipartmax.com/png/full/169-1696957_instagram-icon-instagram-icon-svg-white.png',
                                width: 30),
                            SizedBox(width: 20),
                            Text(
                              'ein.oskar',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.only(
                                  right: 15, left: 15, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff213BD0),
                                    Color(0xff2c46da)
                                  ])),
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
                        child: Icon(Icons.person, color: Colors.white)),
                  ),
                ],
              ));
        });
  }

  Future<void> getTasks(foo) async {
    tasks = [];
    var _tasks = await _dbHelper.getTasks();

    for (int i = 0; i < _tasks.length; i++) {
      if (foo) {
        listKey.currentState!.insertItem(i);
      }
      tasks.add(_tasks[i]);
    }
    if (tasks.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xff262a34),
              title: Text(
                'Erstelle eine neue Aufgabenliste!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('drücke auf das '),
                  Icon(Icons.add),
                  Text(' zum erstellen')
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('ok',
                        style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          )),
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
                            child: Image.asset('assets/icons/logo.png',
                                width: 35)),
                        SizedBox(width: 30),
                        Text(
                          'Aufgaben',
                          style: TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                    SizedBox(),
                    InkWell(
                        onTap: () async {
                          Task _newTask = Task(title: '', description: '');
                          await _dbHelper.insertTask(_newTask, true);
                          listKey.currentState!.insertItem(tasks.length);
                          tasks.insert(tasks.length, _newTask);

                          getTasks(false);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.add))),
                    /*OpenContainer(
                      closedColor: colors[1].withOpacity(0.1),
                      openColor: Colors.transparent.withOpacity(0),
                      closedBuilder: (context, openContainer) {
                        return SvgPicture.asset('assets/icons/avatar.svg',
                            width: 35);
                      },
                      openBuilder: (context, closeContainer) {
                        return Profile(
                          closeContainer: closeContainer,
                          getTasks: getTasks,
                        );
                      },
                    ),*/
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
                              task: Task(
                                  id: tasks[index].id,
                                  title: tasks[index].title,
                                  description: tasks[index].description),
                              notificationSelected: notificationSelected,
                              reloadTasks: getTasks,
                              closeContainer: closeContainer,
                            );
                          },
                          closedBuilder: (_, openContainer) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onLongPress: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xff262a34),
                                          content: Text(
                                            'Willst du die Liste wirklich löschen?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          actions: [
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('abbrechen')),
                                            FlatButton(
                                                onPressed: () {
                                                  listKey.currentState!
                                                      .removeItem(
                                                    index,
                                                    (context, animation) {
                                                      return SizeTransition(
                                                          axis: Axis.vertical,
                                                          sizeFactor: animation,
                                                          child: TaskCardWidget(
                                                            taskId:
                                                                tasks[index].id,
                                                            title: tasks[index]
                                                                .title,
                                                            desc: tasks[index]
                                                                .description,
                                                          ));
                                                    },
                                                  );

                                                  _dbHelper.deleteTask(
                                                      tasks[index].id);
                                                  tasks.removeAt(index);

                                                  getTasks(false);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('löschen',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        );
                                      });
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
