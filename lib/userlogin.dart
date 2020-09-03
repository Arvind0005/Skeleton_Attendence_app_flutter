import 'package:flutter/material.dart';
import 'package:staffattendence05/Userhome.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:staffattendence05/register.dart';
import 'package:staffattendence05/styling.dart';
import 'package:staffattendence05/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staffattendence05/home.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fauth.dart';

class User_login extends StatefulWidget {
  final String adminname;
  User_login({Key key, this.adminname}) : super(key: key);
  @override
  _User_loginState createState() => _User_loginState();
}

class _User_loginState extends State<User_login> {
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
                "Login as staff",
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
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    icon: Icon(Icons.perm_identity),
                    label: Text("Register institute"),
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
                      decoration: styling.copyWith(hintText: "Staff email"),
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
                      decoration: styling.copyWith(hintText: "Staff password"),
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
                        "Login with this location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          setState(() {
                            loading = true;
                            //   DocumentReference user = Firestore.instance.collection("userinfo").document(email);
                          });
                          DocumentSnapshot user = await Firestore.instance
                              .collection(widget.adminname)
                              .document(email)
                              .get();
                          if (user == null) {
                            setState(() {
                              loading = false;
                              error = 'Please enter a valid email address!';
                            });
                          } else {
                            setState(() {
                              loading = false;
                            });
                            if (email == user.data["username"] &&
                                password == user.data["password"]) {
                              setState(() {
                                error = '';
                              });
                              print(user.data["username"]);
                              print(user.data["password"]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Staff_Home(
                                          adminname: widget.adminname,
                                          username: user.data["username"],
                                        )),
                              );
                            } else {
                              error = "the credentials are not matching";
                            }

                            // print("hwbebhdcbuducyucdbhbcdjdksbchbhjdbchb");
                          }
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
