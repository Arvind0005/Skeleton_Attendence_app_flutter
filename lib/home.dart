import 'package:flutter/material.dart';
import 'package:staffattendence05/Login_ins.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:staffattendence05/add_admin.dart';
import 'package:staffattendence05/add_user.dart';
import 'package:staffattendence05/fauth.dart';
import 'package:staffattendence05/register.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  final String adminname;
  final Position Insposition;
  Home({Key key, this.adminname, this.Insposition}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Authservice _auth = Authservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("appbar"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Add_admin(
                            adminname: widget.adminname,
                            Insposition: widget.Insposition,
                          )),
                );
              },
              icon: Icon(Icons.person_add),
              label: Text("Add Admin")),
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Loginins(),
                    ));
              },
              icon: Icon(Icons.exit_to_app),
              label: Text("Log out"))
        ],
      ),
      body: Text("No Users Found To Add Users - Add Admin and Go to Add Users"),
    );
  }
}
