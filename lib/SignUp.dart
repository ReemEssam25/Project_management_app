import 'package:flutter/material.dart';
import 'package:project_management_app/Auth.dart';
import 'package:project_management_app/CustomButton.dart';
import 'package:project_management_app/CustomTextField.dart';
import 'package:project_management_app/TaskStatues.dart';
import 'package:project_management_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FormCustomTextField.dart';
import 'SignIn.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignUp();

}
class _SignUp extends State<SignUp>
{
  final _SignUpKey = GlobalKey<FormState>();
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
          key: _SignUpKey,
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
              FormCustomTextField(hint: "User Name"),
              FormCustomTextField(hint: "Email", controller: emailController, function: (val) {
                setState(() {
                  email = val;
                });
              },),
              FormCustomTextField(hint: "Password" , secure: true,controller: passwordController,function: (val) {
                setState(() {
                  password = val;
                });
              },),
              CustomButton(fun: () async {
                  if (_SignUpKey.currentState.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(email
                        , password);
                    if (result == null)
                      {
                        setState(() {
                          error = 'please supply a valid email and password';
                        });
                      }
                    else{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      //List <String> myUser =[email,password];
                      prefs.setString('user', email);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext ctx) => MyHomePage())).then((value) => _SignUpKey.currentState.reset());
                    }

                }
                  else
                    setState(() {
                      error = 'all fields should be filled';
                    });
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
