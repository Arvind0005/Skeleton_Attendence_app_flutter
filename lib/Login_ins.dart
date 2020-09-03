import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staffattendence05/Userhome.dart';
import 'package:staffattendence05/Usermodel.dart';
import 'package:staffattendence05/add_user.dart';
import 'package:staffattendence05/authenticate.dart';
import 'package:staffattendence05/fauth.dart';
import 'package:staffattendence05/home.dart';
import 'package:staffattendence05/styling.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staffattendence05/loading.dart';
import 'package:staffattendence05/userlogin.dart';
import 'package:provider/provider.dart';
import 'package:staffattendence05/register.dart';

class Loginins extends StatefulWidget {
  @override
  _LogininsState createState() => _LogininsState();
}

class _LogininsState extends State<Loginins> {
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
                "Login your institute",
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
                      decoration: styling.copyWith(hintText: "institute email"),
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
                      decoration:
                          styling.copyWith(hintText: "institute password"),
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
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result =
                              await _auth.Signinwithemailandpassword(
                                  email, password);
                          final String adminname = email;
                          print("1111111111111$adminname");
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Please enter a valid email address!';
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Staff_Home(
                                        adminname: adminname,
                                        username: null,
                                      )),
                            );
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
