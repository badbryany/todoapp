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
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xff121314),
        systemNavigationBarColor: Color(0xff121314),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color(0xff121315),
        scaffoldBackgroundColor: Color(0xff121315),
        accentColor: Colors.white60, //(0xff8e84cf),
        shadowColor: Color(0xff131415),
        buttonColor: Color(0xffc083ff),
        indicatorColor: Color(0xff23252d),
        cardColor: Color(0xff1f2022), // Color(0xff23252d),
        primaryColor: Color(0xffff6a61),
        focusColor: Color(0xffffd234),
        dividerColor: Color(0xff6934ff),
        canvasColor: Color(0xff80d04e),
        hintColor: Color(0xff777e90),
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}
