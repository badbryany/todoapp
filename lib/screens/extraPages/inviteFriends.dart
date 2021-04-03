import 'package:flutter/material.dart';

import '../../global/server.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriends extends StatefulWidget {
  final int taskId;

  InviteFriends({required this.taskId});

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  Server server = Server();

  String username = '';

  List<dynamic> members = [
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
  ];

  List<dynamic> friends = [
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
    {'username': 'max'},
  ];

  void getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  void addMember(String username) async {}

  void removeMember(String username) async {}

  @override
  Widget build(BuildContext context) {
    getUsername();
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(width: 10),
                Text(
                  'Deine Liste mit Freunden verbinden',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Text('teilnehmer'),
                      FutureBuilder(
                        future: server.getMembers(widget.taskId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.37,
                              child: ListView(
                                children: [
                                  ...(snapshot.data! as List).map(
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
                                        title: Text(e['member'].toString()),
                                        trailing: IconButton(
                                          onPressed: () => server.removeMember(
                                              e['member'], widget.taskId),
                                          icon: Icon(Icons.highlight_off),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
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
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Text('einladen'),
                      FutureBuilder(
                        future: server.getFriends(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.37,
                              child: ListView(
                                children: [
                                  ...(snapshot.data! as List).map((e) {
                                    String _username = e['friend_1'] == username
                                        ? e['friend_2']
                                        : e['friend_1'];
                                    return Container(
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
                                        title: Text(_username.toString()),
                                        trailing: IconButton(
                                          onPressed: () => server.addMember(
                                              _username, widget.taskId),
                                          icon:
                                              Icon(Icons.control_point_rounded),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
