import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../Objects/CustomerObject.dart';
import '../Objects/LoginUserObject.dart';

class FirebaseAuthService {
  //Handles Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<CustomerObject> loginUser(LoginUserObject userData) async {
    try {
      print('User Name Is : ${userData.email} and pass: ${userData.password}');
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: userData.email, password: userData.password);
//      SharedPrefs.setStringPreference("uid", user.user.uid);
      print('User Name Is : ${user.user.email} and pass: ${user.user.uid}');
      return CustomerObject(
        customerEmail: user.user.email,
        customerUID: user.user.uid,
      );
    } on PlatformException catch (e) {
      print(e);
      throw PlatformException(
        message: "Wrong username / password",
        code: "403",
      );
    } catch (e) {
      return null;
    }
  }
}
