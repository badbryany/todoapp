import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './loginpage.dart';
import './homepage.dart';

class Profile extends StatefulWidget {
  final Function closeContainer;

  Profile({@required this.closeContainer});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<Color> colors = [
    Color(0xff050609),
    Color(0xff131129),
    Color(0xff874FD0)
  ];
  
  @override
  Widget build(BuildContext context) {
    
    if (!HomePage.loggedIn) {
      return LoginPage();
    } else {
      return Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
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
                //header
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(      
                        children: [
                          FlatButton(
                            onPressed: widget.closeContainer,
                            child: Icon(Icons.arrow_back),
                          ),
                          Text('Mein Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {print('settings');},
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
                        SvgPicture.asset('assets/icons/avatar.svg', width: 80),
                        SizedBox(height: 10),
                        Text('oskar', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('hallo ich heiße Oskar!')
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('63', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Aufgaben'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('23', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Listen'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('13', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Freunde'),
                      ],
                    ),
                  ],
                ),
                //content

                SizedBox(),
              ],
            )
          ),
        ),
      );
    }
  }
}