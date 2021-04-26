import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCustomTextField extends StatelessWidget {
  const FormCustomTextField({
    Key key, this.hint, this.secure, this.controller, this.inputType, this.function,
  }) : super(key: key);

  final String hint ;
  final bool secure;
  final TextEditingController controller;
  final TextInputType inputType;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      child: TextFormField(
        obscureText: secure==null ? false:secure ,
        keyboardType: inputType == null ? TextInputType.text : inputType,
        onChanged: function,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This Field cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: hint,
        ),
      ),
    );
  }
}