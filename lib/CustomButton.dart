import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key, this.fun, this.title,
  }) : super(key: key);

  final Function fun;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: fun,
        child: Text(title, style: TextStyle(fontSize: 20),),
        style: ElevatedButton.styleFrom(
          primary: Colors.purpleAccent,
          minimumSize: Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20)
          )
        )
      ),
    );
  }
}