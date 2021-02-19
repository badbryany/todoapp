import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xff131129), systemNavigationBarColor: Color(0xff050609)),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color(0xff1f1d2b),
        brightness: Brightness.dark,
        fontFamily: 'Poppins'
      ),
      home: HomePage(),
    );
  }
}