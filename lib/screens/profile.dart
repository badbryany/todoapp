import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/database_helper.dart';

import './loginpage.dart';
import './homepage.dart';

import '../models/submitButton.dart';

class Profile extends StatefulWidget {
  final Function closeContainer;
  final Function? getTasks;

  Profile({required this.closeContainer, this.getTasks});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String username = '...';
  String description = '';

  int todoCount = 0;
  int taskCount = 0;
  int friends = 0;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _todos = await _dbHelper.getTodos();
    var _tasks = await _dbHelper.getTasks();

    setState(() {
      username = prefs.getString('username');
      todoCount = _todos.length;
      taskCount = _tasks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    if (HomePage.loggedIn) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //header
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap:
                                    widget.closeContainer as void Function()?,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 24),
                                    child: Icon(Icons.arrow_back)),
                              ),
                              Text('Mein Profil',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              //SharedPreferences.getInstance().then((i) => i.clear());
                            },
                          ),
                        ],
                      ),
                    ),
                    //Profile Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/icons/avatar.svg',
                                width: 80),
                            SizedBox(height: 10),
                            Text(username,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(description)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$todoCount',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Aufgaben'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$taskCount',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Listen'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$friends',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Freunde'),
                          ],
                        ),
                      ],
                    ),
                    //content
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView(
                        children: [
                          ...[
                            'max',
                            'moritz',
                            'ben',
                            'flora',
                            'arthur',
                            'rafael',
                            'theo',
                            'tina'
                          ].map(
                            (e) => Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).cardColor,
                              ),
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text(e),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SubmitButton(
                    onPressed: () {},
                    text: 'Freund hinzufügen',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (!HomePage.connection) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.closeContainer as void Function()?,
                            child: Padding(
                                padding: EdgeInsets.only(right: 24),
                                child: Icon(Icons.arrow_back)),
                          ),
                          Text('Mein Profil',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          //SharedPreferences.getInstance().then((i) => i.clear());
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.signal_wifi_off, color: Colors.red, size: 33),
                      SizedBox(height: 15),
                      Text(
                        'du bist offline',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return LoginPage(widget.getTasks);
    }
  }
}
