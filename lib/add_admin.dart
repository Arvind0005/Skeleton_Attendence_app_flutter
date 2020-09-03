import 'package:flutter/material.dart';
import 'package:staffattendence05/Login_ins.dart';
import 'package:staffattendence05/database.dart';
import 'package:staffattendence05/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'fauth.dart';
import 'package:staffattendence05/styling.dart';
import 'package:staffattendence05/home.dart';
import 'package:staffattendence05/Userhome.dart';

class Add_admin extends StatefulWidget {
  final String adminname;
  final Position Insposition;
  Add_admin({Key key, this.adminname, this.Insposition}) : super(key: key);
  @override
  _Add_adminState createState() => _Add_adminState();
}

class _Add_adminState extends State<Add_admin> {
  @override
  final _formkey = GlobalKey<FormState>();

  String email = '';

  String error = '';

  String password = '';

  bool loading = false;

  final Authservice _auth = Authservice();

  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(
                "Add Admin",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginins()),
                      );
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"),
                    color: Colors.teal,
                  ),
                )
              ],
              backgroundColor: Colors.green[400],
            ),
            body: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                    ),
                    TextFormField(
                      decoration: styling.copyWith(hintText: "Admin email"),
                      validator: (val) {
                        return val.isEmpty
                            ? "please enter an valid email id"
                            : null;
                      },
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: styling.copyWith(hintText: "Admin password"),
                      validator: (val) => val.length < 6
                          ? "a password should contain atleast 6 characters"
                          : null,
                      onChanged: (val) => password = val,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      color: Colors.green[400],
                      child: Text(
                        "Add Admin",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
//                          setState(() {
//                            loading = true;
//                          });
                          double Insposition_lat = widget.Insposition.latitude;
                          double Insposition_long =
                              widget.Insposition.longitude;
                          await Database_service(
                                  username: email, adminname: widget.adminname)
                              .updateuserinfo(password, false, Insposition_lat,
                                  Insposition_long);
                          setState(() {
                            loading = false;
                          });
                          print("1111111111111$email");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Staff_Home(
                                      adminname: widget.adminname,
                                      username: email,
                                      Insposition: widget.Insposition,
                                    )),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      error,
                      style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
