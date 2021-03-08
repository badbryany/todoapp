import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requests/requests.dart';

import './homepage.dart';

import '../models/inputField.dart';
import '../models/submitButton.dart';

import '../server.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<Color> colors = [
    Color(0xff050609),
    Color(0xff131129),
    Color(0xff874FD0)
  ];
  static String username = '';
  static String password = '';

  static String error = 'Gib etwas ein';

  Widget? content;

  void setWidget(Widget nextWidget) {
    if (error == '') {
      setState(() {
        content = nextWidget;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xff262a34),
              content: Text(
                error,
                textAlign: TextAlign.center,
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
    if (content == null) {
      content = GetUsername(setWidget);
    }
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
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    child: child,
                    scale: animation,
                  );
                },
                child: content),
          ),
        ),
      ),
    );
  }
}

class GetUsername extends StatefulWidget {
  final Function setWidget;

  GetUsername(this.setWidget);

  @override
  _GetUsernameState createState() => _GetUsernameState();
}

class _GetUsernameState extends State<GetUsername> {
  Widget? hint;
  Widget? suffixWidget;

  void setSuffixWidget(Widget newWidget) {
    setState(() {
      suffixWidget = newWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Benutzername wählen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        SizedBox(height: 15),
        Text('Du kannst ihn jederzeit ändern.',
            style: TextStyle(color: Colors.grey)),
        SizedBox(height: 5),
        SizedBox(height: 20),
        InputField(
            icon: Icon(Icons.person),
            hintText: 'Benutzername',
            obscureText: false,
            suffixWidget: suffixWidget,
            onChange: (value) {
              checkUsername(username: value, setWidget: setSuffixWidget);
              _RegisterPageState.username = value;
            },
            initialValue: ''),
        SubmitButton(
            text: 'weiter',
            onPressed: () {
              if (_RegisterPageState.username.length == 0) {
                _RegisterPageState.error = 'Gib einen Benutzernamen ein';
              }
              widget.setWidget(GetPassword(widget.setWidget));
            })
      ],
    );
  }
}

class GetPassword extends StatefulWidget {
  final Function setWidget;

  GetPassword(this.setWidget);

  @override
  _GetPasswordState createState() => _GetPasswordState();
}

class _GetPasswordState extends State<GetPassword> {
  @override
  Widget build(BuildContext context) {
    Color hintColor = Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Passwort wählen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        SizedBox(height: 15),
        Text('mindestens 6 Zeichen', style: TextStyle(color: hintColor)),
        SizedBox(height: 20),
        InputField(
          icon: Icon(Icons.person),
          hintText: 'Passwort',
          obscureText: true,
          suffixWidget: SizedBox(),
          onChange: (value) {
            _RegisterPageState.password = value;
          },
        ),
        SubmitButton(
          text: 'weiter',
          onPressed: () {
            if (_RegisterPageState.password.length >= 6) {
              _RegisterPageState.error = '';
            } else {
              _RegisterPageState.error = 'das Passwort ist zu kurz';
            }
            widget.setWidget(FinalRegister(widget.setWidget));
          },
        )
      ],
    );
  }
}

class FinalRegister extends StatelessWidget {
  final Function setWidget;

  FinalRegister(this.setWidget);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          register(_RegisterPageState.username, _RegisterPageState.password),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logo.png', width: 75),
                  SizedBox(height: 30),
                  Text(
                      'Willkommen bei TickIt!,\n${_RegisterPageState.username}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 15),
                  Text(
                      'Jetzt kannst du alle Funktionen von TickIt! verwenden und deine Aufgaben mit Freunden zusammen beweltigen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                  SizedBox(height: 20),
                  SubmitButton(
                    text: 'fertig',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    'Es ist etwas schief gelaufen.\nBitte setze dich mit dem Entwickler in Verbindung!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 23)),
                SizedBox(height: 20),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back)),
              ],
            );
          }
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Registrieren...', style: TextStyle(fontSize: 25)),
              SizedBox(height: 50),
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}

void checkUsername({required String username, Function? setWidget}) async {
  print('checking username...');
  if (username.length != 0) {
    setWidget!(SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        )));
    var r =
        await Requests.get('${Server().url}/checkUsername?username=$username');

    if (r.content() == 'available') {
      _RegisterPageState.error = '';
      setWidget(Icon(
        Icons.check,
        color: Colors.greenAccent[400],
        size: 30,
      ));
    } else {
      _RegisterPageState.error = 'Der Benutzername wird bereits verwendet...';
      print(_RegisterPageState.error);
      setWidget(Icon(
        Icons.clear,
        color: Colors.red[700],
        size: 30,
      ));
    }
  } else {
    _RegisterPageState.error = 'Der Benutzername ist zu kurz...';
  }
}

Future<bool> register(String username, String password) async {
  print('try to log in...');
  var r = await Requests.post(
    '${Server().url}/register',
    json: {'username': username, 'password': password},
  );
  if (r.content() == 'success') {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);
    prefs.setString('password', password);

    return true;
  } else {
    return false;
  }
}
