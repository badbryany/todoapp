import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final bool obscureText;
  final Function onChange;
  final String initialValue;
  final Widget suffixWidget;

  InputField({this.icon, this.hintText, this.obscureText, this.onChange, this.initialValue, this.suffixWidget});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff262a34),
      ),
      child: TextFormField(
        obscureText: obscureText,
        initialValue: initialValue,
        decoration: InputDecoration(
          suffix: Container(
            margin: EdgeInsets.only(right: 25),
            child: suffixWidget
          ),
          labelText: hintText,
          labelStyle: TextStyle(fontSize: 14),
          hintText: hintText,
          prefixIcon: icon,
          border: InputBorder.none,
        ),
        onChanged: onChange,
      ),
    );
  }
}
