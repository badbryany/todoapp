import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/database_helper.dart';
import '../global/server.dart';

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
  Server server = Server();

  String username = '...';
  String description = '';

  int todoCount = 0;
  int taskCount = 0;
  int friends = 0;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _todos = await _dbHelper.getTodos();
    var _tasks = await _dbHelper.getTasks();

    List _friends = await server.getFriends();

    setState(() {
      username = prefs.getString('username');
      todoCount = _todos.length;
      taskCount = _tasks.length;
      friends = _friends.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (todoCount == 0) {
      getData();
    }
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
                                  child: Icon(Icons.arrow_back),
                                ),
                              ),
                              Text(
                                'Mein Profil',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          OpenContainer(
                            closedColor: Theme.of(context).backgroundColor,
                            openColor: Theme.of(context).backgroundColor,
                            closedBuilder: (context, openContainer) {
                              return IconButton(
                                onPressed: openContainer,
                                icon: Icon(Icons.new_releases),
                              );
                            },
                            openBuilder: (context, closeContainer) {
                              return FriendshipRequests(
                                closeContainer: closeContainer,
                              );
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
                            SvgPicture.asset(
                              'assets/icons/avatar.svg',
                              width: 80,
                            ),
                            SizedBox(height: 10),
                            Text(
                              username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                            Text(
                              '$taskCount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                      child: FutureBuilder(
                        future: server.getFriends(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            friends = (snapshot.data! as List).length;
                            return ListView(
                              children: [
                                ...((snapshot.data!) as List).map(
                                  (e) => Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: ListTile(
                                      leading: SvgPicture.asset(
                                        'assets/icons/avatar.svg',
                                        width: 30,
                                      ),
                                      title: Text(
                                        e['friend_1'] == username
                                            ? e['friend_2']
                                            : e['friend_1'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: LinearProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: OpenContainer(
                    closedColor: Theme.of(context).backgroundColor,
                    openColor: Theme.of(context).backgroundColor,
                    closedBuilder: (context, openContainer) {
                      return SubmitButton(
                        onPressed: openContainer,
                        text: 'Freund hinzufügen',
                      );
                    },
                    openBuilder: (context, closeContainer) {
                      return NewFriend(
                        closeContainer: closeContainer,
                      );
                    },
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

class NewFriend extends StatefulWidget {
  final Function closeContainer;

  NewFriend({
    required this.closeContainer,
  });

  @override
  _NewFriendState createState() => _NewFriendState();
}

class _NewFriendState extends State<NewFriend> {
  void newFriend(String name) {
    Server().newFriend(name);
    widget.closeContainer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => widget.closeContainer(),
                      icon: Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Freund hinzufügen',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded),
                ),
              ],
            ),
            FutureBuilder(
              future: Server().getPeople(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    print(snapshot.data);
                    return Expanded(
                      child: ListView(
                        children: [
                          ...(snapshot.data! as List).map(
                            (e) => Container(
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  'assets/icons/avatar.svg',
                                  width: 40,
                                ),
                                title: Text(
                                  e['username'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(e['description']),
                                isThreeLine: true,
                                trailing: IconButton(
                                  onPressed: () =>
                                      this.newFriend(e['username']),
                                  icon: e['friends'] == true
                                      ? Icon(Icons.how_to_reg)
                                      : Icon(Icons.person_add_rounded),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('...'),
                    );
                  }
                } else {
                  return Center(
                    child: LinearProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FriendshipRequests extends StatefulWidget {
  final Function closeContainer;

  FriendshipRequests({
    required this.closeContainer,
  });

  @override
  _FriendshipRequestsState createState() => _FriendshipRequestsState();
}

class _FriendshipRequestsState extends State<FriendshipRequests> {
  void acceptRequest(String name) async {
    await Server().acceptRequest(name);
    setState(() {});
  }

  void denyRequest(String name) async {
    await Server().denyRequest(name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    this.widget.closeContainer();
                    setState(() {});
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(width: 10),
                Text(
                  'Freundschaftsanfragen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: Server().getReuests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    if ((snapshot.data! as List).length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text('keine Anfragen'),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView(
                        children: [
                          ...(snapshot.data! as List).map(
                            (e) => ListTile(
                              leading: SvgPicture.asset(
                                'assets/icons/avatar.svg',
                                width: 40,
                              ),
                              title: Text(
                                e['friend_1'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //subtitle: Text("e['description']"),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          this.acceptRequest(e['friend_1']),
                                      icon: Icon(
                                        Icons.check,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          this.denyRequest(e['friend_1']),
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('keine Anfragen'),
                    );
                  }
                } else {
                  return Center(
                    child: LinearProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
