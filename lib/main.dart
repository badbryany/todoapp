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
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xff272636), systemNavigationBarColor: Color(0xff1f1d2b)),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color(0xff1f1d2b),
        brightness: Brightness.dark,
        fontFamily: 'Poppins'
      ),
      home: Homepage(),
    );
  }
}