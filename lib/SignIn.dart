import 'package:flutter/material.dart';
import 'package:project_management_app/CustomButton.dart';
import 'package:project_management_app/CustomTextField.dart';
import 'package:project_management_app/SignUp.dart';
import 'package:project_management_app/TaskStatues.dart';
import 'package:project_management_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth.dart';
import 'FormCustomTextField.dart';

class SignIn extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignIn();

}
class _SignIn extends State<SignIn>
{
  final _SignInKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = "";
  String password = "";
  final AuthService _auth = AuthService();
  String error ='';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Form (
          key: _SignInKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent,
                ),
                child: Center(child: Text("WELCOME" , style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900), )),
              ),
              SizedBox(
                height: 20,
              ),
              FormCustomTextField(hint: "Email", function: (val) {
                setState(() {
                  email = val;
                });
              },),
              FormCustomTextField(hint: "Password" , secure: true, function: (val) {
                setState(() {
                  password = val;
                });
              },),
              CustomButton(fun: () async {
                if (_SignInKey.currentState.validate()) {
                  dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                  if (result == null)
                  {
                    setState(() {
                      error = "couldn't sign in with those credentials";
                    });
                  }
                  else{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('user', email);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext ctx) => MyHomePage())).then((value) => _SignInKey.currentState.reset());
                }}},
                title: "SignIn",

              ),
              CustomButton(fun: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
                title: "SignUp",
              ),
              Text(error, style: TextStyle(color: Colors.red),),
            ],
          ),
        ),
      ),
    );
  }

}