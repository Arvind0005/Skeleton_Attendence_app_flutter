import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:geolocator/geolocator.dart';

class Database_service {
  final String username;
  final String adminname;
  Database_service({this.username, this.adminname});
  String name = "hello";

  Future updateuserinfo(String password, bool attendence,
      double Insposition_lat, double Insposition_long) async {
    final CollectionReference userinfo =
        Firestore.instance.collection(adminname);
    return await userinfo.document(username).setData({
      "username": username,
      "password": password,
      "attendence": attendence,
      "Insposition_lat": Insposition_lat,
      "Insposition_long": Insposition_long,
    });
  }

  Future update_userdata(String username) async {
    DocumentReference docref =
        Firestore.instance.collection('username').document('usernames');
    DocumentSnapshot doc = await docref.get();
    return await docref.updateData({
      'username': FieldValue.arrayUnion([username])
    });
  }

  Future update_passworddata(String password) async {
    DocumentReference docref =
        Firestore.instance.collection('password').document('password');
    DocumentSnapshot doc = await docref.get();
    return await docref.updateData({
      'password': FieldValue.arrayUnion([password])
    });
  }

  User userfromsnapshot(DocumentSnapshot snapshot) {
    return User(
      username: username,
      password: snapshot.data["password"],
      attendence: snapshot.data['attendence'],
    );
  }

  List<User> userlistfromsnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
        username: doc.data["username"],
        password: doc.data["password: "],
        attendence: doc.data["attendence"],
      );
    }).toList();
  }

  Stream<QuerySnapshot> get userdata {
    return Firestore.instance.collection(adminname).snapshots();
  }
}
