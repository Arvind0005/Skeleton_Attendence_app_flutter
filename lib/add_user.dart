import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staffattendence05/adminmodel.dart';
import 'package:staffattendence05/database.dart';
import 'package:staffattendence05/fauth.dart';
import 'package:staffattendence05/styling.dart';
import 'package:staffattendence05/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'Usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Adduser extends StatefulWidget {
  final String adminname;
  final Position Insposition;
  Adduser({Key key, this.adminname, this.Insposition}) : super(key: key);
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  @override
  final _formkey = GlobalKey<FormState>();
  // Admin _admin = Admin();
  User _user = User();
  bool duplicate = false;
  String error = '';
  int i;
  bool loading = false;
  String username = '';
  String password = '';
  final Authservice _auth = Authservice();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _xcontroller = TextEditingController();

  Widget build(BuildContext context) {
//    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Database_service(username: null, adminname: widget.adminname)
            .userdata,
        builder: (context, snapshot) {
          List<DocumentSnapshot> user = snapshot.data.documents;
          //print(user.uid);
          return loading
              ? Loading()
              : Scaffold(
                  backgroundColor: Colors.teal,
                  appBar: AppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    title: Text(
                      "Add a staff",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: Colors.green[400],
                  ),
                  body: Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 120.0,
                            ),
                            TextFormField(
                              controller: _controller,
                              decoration:
                                  styling.copyWith(hintText: "User email"),
                              validator: (val) {
                                return val.isEmpty
                                    ? "please enter an valid email id"
                                    : null;
                              },
                              onChanged: (val) {
                                username = val;
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: _xcontroller,
                              obscureText: true,
                              decoration:
                                  styling.copyWith(hintText: "User password"),
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
                                "Add User",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                print(widget.adminname);
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  for (i = 0; i < user.length; i++) {
                                    if (user[i].data["username"] == username) {
                                      setState(() {
                                        duplicate = true;
                                      });
                                    }
                                  }
                                  if (duplicate) {
                                    setState(() {
                                      error =
                                          'this username is already present';
                                      loading = false;
                                    });
                                  } else {
                                    double Insposition_lat =
                                        widget.Insposition.latitude;
                                    double Insposition_long =
                                        widget.Insposition.longitude;
                                    await Database_service(
                                            username: username,
                                            adminname: widget.adminname)
                                        .updateuserinfo(password, false,
                                            Insposition_lat, Insposition_long);
                                  }
                                  setState(() {
                                    _xcontroller.clear();
                                    _controller.clear();
                                    error = '';
                                    loading = false;
                                  });
                                  if (!duplicate) {
                                    setState(() {
                                      loading = false;
                                    });
                                    final snackBar = SnackBar(
                                      content: Text('User successfully added!'),
                                      duration: const Duration(minutes: 1),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content:
                                          Text('Username is already present'),
                                      duration: const Duration(seconds: 15),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      duplicate = false;
                                    });
                                  }
                                }
                              },
                            ),
                            RaisedButton(
                              child: Text("Done"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              error,
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
        });
  }
}
