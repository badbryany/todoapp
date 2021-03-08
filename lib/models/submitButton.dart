import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function? onPressed;

  SubmitButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onPressed as void Function()?,
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Color(0xff213BD0), Color(0xff2c46da)]
            )
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
