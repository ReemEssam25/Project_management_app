import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key key,this.linesNum , this.hint, this.verNum, this.controller, this.secure}) : super(key: key);

  final int linesNum ;
  final double verNum;
  final String hint;
  final TextEditingController controller;
  final bool secure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verNum, horizontal: 35),
      child: TextField(
        maxLines: linesNum,
        controller: controller,
        obscureText: secure==null ? false:secure ,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: hint,
        ),
      ),
    );
  }
}