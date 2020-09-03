import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:staffattendence05/adminmodel.dart';
import 'package:geolocator/geolocator.dart';

class Authservice {
  String error = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Admin _userfromfirebase(FirebaseUser admin) {
    return admin != null ? Admin(uid: admin.uid, email: admin.email) : null;
  }

  Stream<Admin> get admin {
    return _auth.onAuthStateChanged.map(_userfromfirebase);
  }

  Future Signinwithemailandpassword(
    String email,
    String password,
  ) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser admin = result.user;
      return _userfromfirebase(admin);
    } catch (e) {
      print(e.toString());
    }
  }

  Future Signupwithemailandpassword(
      String email, String password, Position position) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser admin = result.user;
      print(admin.email);
      print(admin.uid);
      print("admin signed in");
      return _userfromfirebase(admin);
    } catch (e) {
      error = 'not a vaild email';
      print("user not signed in");
      print(e.toString());
      return null;
    }
  }

  Future Signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
