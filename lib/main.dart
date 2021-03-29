import 'package:flutter/material.dart';

import './screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        backgroundColor: Color(0xff121315),
        scaffoldBackgroundColor: Color(0xff121315),
        accentColor: Colors.white60, //(0xff8e84cf),
        shadowColor: Color(0xff131415),
        buttonColor: Color(0xffc083ff),
        indicatorColor: Color(0xff23252d),
        cardColor: Color(0xff21242b), // Color(0xff23252d),
        primaryColor: Color(0xffee786d),
        focusColor: Color(0xffffb102),
        dividerColor: Color(0xff19abfa),
        canvasColor: Color(0xff80d04e),
        hintColor: Color(0xff777e90),
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
      ),
      theme: ThemeData(
        backgroundColor: Color(0xffdff9f8),
        scaffoldBackgroundColor: Color(0xffdff9f8),
        accentColor: Colors.white60, //(0xff8e84cf),
        shadowColor: Colors.white70,
        buttonColor: Color(0xffc083ff),
        indicatorColor: Color(0xff23252d),
        cardColor: Color(0xfff1f8ff), // Color(0xff23252d),
        primaryColor: Color(0xffff8048),
        focusColor: Color(0xffeebd6c),
        dividerColor: Color(0xff00b6ff),
        canvasColor: Color(0xff69a254),
        hintColor: Color(0xff777e90),
        brightness: Brightness.light,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}
 /*
 import 'package:flutter/material.dart';

import './screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        backgroundColor: Color(0xff121315),
        scaffoldBackgroundColor: Color(0xff121315),
        accentColor: Colors.white60, //(0xff8e84cf),
        shadowColor: Color(0xff131415),
        buttonColor: Color(0xffc083ff),
        indicatorColor: Color(0xff23252d),
        cardColor: Color(0xff21242b), // Color(0xff23252d),
        primaryColor: Color(0xffff6a61),
        focusColor: Color(0xffffd234),
        dividerColor: Color(0xff6934ff),
        canvasColor: Color(0xff80d04e),
        hintColor: Color(0xff777e90),
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
      ),
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.white60, //(0xff8e84cf),
        shadowColor: Color(0xff789598),
        buttonColor: Color(0xffc083ff),
        indicatorColor: Color(0xff23252d),
        cardColor: Color(0xfff1f8ff), // Color(0xff23252d),
        primaryColor: Color(0xffc59291),
        focusColor: Color(0xffeebd6c),
        dividerColor: Color(0xff90d7de),
        canvasColor: Color(0xff69a254),
        hintColor: Color(0xff777e90),
        brightness: Brightness.light,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}
 */