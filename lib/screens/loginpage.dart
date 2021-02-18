import 'package:flutter/material.dart';

import '../models/inputField.dart';
import '../models/submitButton.dart';

import '../screens/registerpage.dart';

class LoginPage extends StatelessWidget {
  final Function closeContainer;

  LoginPage({@required this.closeContainer});

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
          )
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: closeContainer,
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)
                  ],
                )
              ),

              //content body
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'TickIt!',
                    style: TextStyle(
                      fontFamily: 'Truculenta',
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: 20),
                  InputField(
                    icon: Icon(Icons.person),
                    hintText: 'Benutzername',
                    obscureText: false,
                    onChange: (value) {},
                    initialValue: ''
                  ),
                  InputField(
                    icon: Icon(Icons.person),
                    hintText: 'Passwort',
                    obscureText: true,
                    onChange: (value) {},
                    initialValue: ''
                  ),
                  SubmitButton(
                    text: 'Anmelden'
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
                      color: Colors.grey[600]
                    ),
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
                              builder: (context) => RegisterPage()
                            ),
                          ),
                          child: Text('Registriere dich.', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                )
              ),
            ],
          ),
        )
      )
    );
  }
}