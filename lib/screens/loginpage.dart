import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';

import '../models/inputField.dart';
import '../models/submitButton.dart';

import '../screens/registerpage.dart';
import '../screens/homepage.dart';

import '../server.dart';

class LoginPage extends StatefulWidget {
  final Function getTasks;

  LoginPage(this.getTasks);

  static Future<bool> login(String username, String password) async {
    var r = await Requests.post('${Server().url}/login',
        json: {'username': username, 'password': password});
    if (r.content() == 'true') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('username', username);
      prefs.setString('password', password);

      print('you are logged in as $username.\npassword: $password');

      return true;
    } else {
      return false;
    }
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username;

  String password;

  String hint = '';

  final List<Color> colors = [
    Color(0xff050609),
    Color(0xff131129),
    Color(0xff874FD0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
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
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                          ),
                          Text(
                            'Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )
                        ],
                      )),

                  //content body
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('TickIt!',
                          style: TextStyle(
                              fontFamily: 'Truculenta',
                              fontSize: 45,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      InputField(
                        icon: Icon(Icons.person),
                        hintText: 'Benutzername',
                        obscureText: false,
                        onChange: (value) {
                          username = value;
                        },
                        initialValue: '',
                        suffixWidget: SizedBox(),
                      ),
                      InputField(
                          icon: Icon(Icons.lock),
                          hintText: 'Passwort',
                          obscureText: true,
                          onChange: (value) {
                            password = value;
                          },
                          suffixWidget: SizedBox(),
                          initialValue: ''),
                      Text(hint, style: TextStyle(color: Colors.red)),
                      SubmitButton(
                        text: 'Anmelden',
                        onPressed: () async {
                          bool res = await LoginPage.login(username, password);

                          if (res) {
                            setState(() {
                              hint = '';
                            });
                            HomePage.loggedIn = true;
                            widget.getTasks(true);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              hint = 'Benutzername oder Passwort ist falsch';
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  //footer
                  Positioned(
                      left: 19,
                      right: 19,
                      bottom: 70,
                      child: Column(
                        children: [
                          Container(
                              height: 0.5,
                              width: double.infinity,
                              color: Colors.grey[600]),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Du hast kein Konto?'),
                              SizedBox(width: 5),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                ),
                                child: Text('Registriere dich.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            )));
  }
}
