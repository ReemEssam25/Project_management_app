import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_management_app/MyUser.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser _userFromFirebaseUser (FirebaseUser user)
  {
    return user!=null ? MyUser(uid: user.uid) : null;
  }

  /*Stream<MyUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser(user));
  }*/

  Future registerWithEmailAndPassword(String email, String password)async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      print(email);
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  signOut()
  async {
    await FirebaseAuth.instance.signOut();
  }

}