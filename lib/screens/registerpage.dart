import 'package:flutter/material.dart';

import './homepage.dart';

import '../models/inputField.dart';
import '../models/submitButton.dart';

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
  
  Widget content;

  void setWidget(Widget nextWidget) {
    setState(() {
      content = nextWidget;
    });
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
          )
        ),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation,);
              },
              child: content
            ),
          ),
        ),
      ),
    );
  }
}

class GetUsername extends StatelessWidget {
  final Function setWidget;

  GetUsername(this.setWidget);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Benutzername wählen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        SizedBox(height: 15),
        Text('Du kannst ihn jederzeit ändern.', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 20),
        InputField(
          icon: Icon(Icons.person),
          hintText: 'Benutzername',
          obscureText: false,
          onChange: (value) {
            _RegisterPageState.username = value;
          },
          initialValue: ''
        ),
        SubmitButton(
          text: 'weiter',
          onPressed: () {
            if (_RegisterPageState.username.length != 0) {
              setWidget(GetPassword(setWidget));
            }
          }
        )
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
        Text('Passwort wählen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        SizedBox(height: 15),
        Text('mindestens 6 Zeichen', style: TextStyle(color: hintColor)),
        SizedBox(height: 20),
        InputField(
          icon: Icon(Icons.person),
          hintText: 'Passwort',
          obscureText: true,
          onChange: (value) {
            _RegisterPageState.password = value;
          },
          initialValue: ''
        ),
        SubmitButton(
          text: 'weiter',
          onPressed: () {
            if (_RegisterPageState.password.length >= 6) {
              widget.setWidget(FinalRegister(widget.setWidget));
            } else {
              print('no');
              setState(() {
                hintColor = Colors.red;
              });
            }
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
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icons/logo.png', width: 75),
          SizedBox(height: 30),
          Text(
            'Willkommen bei TickIt!,\n${_RegisterPageState.username}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
            )
          ),
          SizedBox(height: 15),
          Text(
            'Jetzt kannst du alle Funktionen von TickIt! verwenden und deine Aufgaben mit Freunden zusammen beweltigen!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            )
          ),
          SizedBox(height: 20),
          SubmitButton(
            text: 'fertig',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage()
              ),
            ),
          )
        ],
      ),
    );
  }
}