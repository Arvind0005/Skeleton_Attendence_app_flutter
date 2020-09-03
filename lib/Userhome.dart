import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staffattendence05/Login_ins.dart';
import 'package:staffattendence05/add_user.dart';
import 'package:staffattendence05/database.dart';
import 'userlogin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staffattendence05/add_admin.dart';

class Staff_Home extends StatefulWidget {
  final String username;
  final String adminname;
  final Position Insposition;
  Staff_Home({Key key, this.adminname, this.username, this.Insposition})
      : super(key: key);
  @override
  _Staff_HomeState createState() => _Staff_HomeState();
}

class _Staff_HomeState extends State<Staff_Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database_service(
                username: widget.username, adminname: widget.adminname)
            .userdata,
        builder: (context, snapshot) {
          List<DocumentSnapshot> user = snapshot.data.documents;
          if (user.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text("appbar"),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Add_admin(adminname: widget.adminname)),
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
              body: Text(
                  "No Users Found To Add Users - Add Admin and Go to Add Users"),
            );
          } else if (widget.username == null) {
            print(widget.username);
            Scaffold(
              appBar: AppBar(
                title: Text("Staff home"),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  User_login(adminname: widget.adminname),
                            ));
                      },
                      icon: Icon(Icons.person),
                      label: Text("Login"))
                ],
              ),
              body: ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    if (user[index].data["username"] == widget.username) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.brown[100],
                          ),
                          title: Text(user[index].data["username"]),
                          subtitle: Text(user[index].data["attendence"]
                              ? "present"
                              : "absent"),
                          onTap: () async {
                            double Insposition_lat =
                                user[index].data["Insposition_lat"];
                            double Insposition_long =
                                user[index].data["Insposition_long"];
                            Position position = await getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.best);
                            print(
                                "insssssssssssssssssslocation${user[index].data["Insposition_lat"]}${user[index].data["Insposition_long"]}");
                            print("currrrrrrrrrrrrrrrrrrrent=$position");
                            final distance = GeolocatorPlatform.distanceBetween(
                                Insposition_lat,
                                Insposition_long,
                                position.latitude,
                                position.longitude);
                            print(distance);
                            if (distance <= 100) {
                              Database_service(
                                      username: widget.username,
                                      adminname: widget.adminname)
                                  .updateuserinfo(
                                user[index].data["password"],
                                !user[index].data["attendence"],
                                Insposition_lat,
                                Insposition_long,
                              );
                            } else {
                              final snackBar = SnackBar(
                                content: Text('Username is already present'),
                                duration: const Duration(seconds: 3),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
//                            Database_service(
//                                    username: widget.username,
//                                    adminname: widget.adminname)
//                                .updateuserinfo(
//                                    user[index].data["password"],
//                                    !user[index].data["attendence"],
//                                    widget.Insposition);
                          },
                        ),
                      );
                    }
                    return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.brown[100],
                            ),
                            title: Text(user[index].data["username"]),
                            subtitle: Text(user[index].data["attendence"]
                                ? "present"
                                : "absent")));
                  }),
            );
          } else if (user[0].data['username'] == widget.username) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Staff home"),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Adduser(
                                adminname: widget.adminname,
                                Insposition: widget.Insposition,
                              ),
                            ));
                      },
                      icon: Icon(Icons.person_add),
                      label: Text("Add User")),
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginins(),
                            ));
                      },
                      icon: Icon(Icons.exit_to_app),
                      label: Text("Logout"))
                ],
              ),
              body: ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    if (user[index].data["username"] == widget.username) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.brown[100],
                          ),
                          title: Text(user[index].data["username"]),
                          subtitle: Text(user[index].data["attendence"]
                              ? "present"
                              : "absent"),
                          onTap: () async {
                            double Insposition_lat =
                                user[index].data["Insposition_lat"];
                            double Insposition_long =
                                user[index].data["Insposition_long"];
                            Position position = await getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.best);
                            print(
                                "insssssssssssssssssslocation${widget.Insposition}");
                            print("currrrrrrrrrrrrrrrrrrrent=$position");
                            final distance = GeolocatorPlatform.distanceBetween(
                                Insposition_lat,
                                Insposition_long,
                                position.latitude,
                                position.longitude);
                            print(distance);
                            if (distance <= 100) {
                              Database_service(
                                      username: widget.username,
                                      adminname: widget.adminname)
                                  .updateuserinfo(
                                user[index].data["password"],
                                !user[index].data["attendence"],
                                Insposition_lat,
                                Insposition_long,
                              );
                            } else {
                              final snackBar = SnackBar(
                                content:
                                    Text('please move closer to the institute'),
                                duration: const Duration(seconds: 3),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
//                            Database_service(
//                                    username: widget.username,
//                                    adminname: widget.adminname)
//                                .updateuserinfo(
//                                    user[index].data["password"],
//                                    !user[index].data["attendence"],
//                                    widget.Insposition);
                          },
                        ),
                      );
                    }
                    return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.brown[100],
                            ),
                            title: Text(user[index].data["username"]),
                            subtitle: Text(user[index].data["attendence"]
                                ? "present"
                                : "absent")));
                  }),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Staff home"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                User_login(adminname: widget.adminname),
                          ));
                    },
                    icon: Icon(Icons.person_add),
                    label: Text("User Login")),
                FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginins(),
                          ));
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"))
              ],
            ),
            body: ListView.builder(
                itemCount: user.length,
                itemBuilder: (context, index) {
                  if (user[index].data["username"] == widget.username) {
                    return Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.brown[100],
                        ),
                        title: Text(user[index].data["username"]),
                        subtitle: Text(user[index].data["attendence"]
                            ? "present"
                            : "absent"),
                        onTap: () async {
                          double Insposition_lat =
                              user[index].data["Insposition_lat"];
                          double Insposition_long =
                              user[index].data["Insposition_long"];
                          Position position = await getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best);
                          print(
                              "insssssssssssssssssslocation${widget.Insposition}");
                          print("currrrrrrrrrrrrrrrrrrrent=$position");
                          final distance = GeolocatorPlatform.distanceBetween(
                              Insposition_lat,
                              Insposition_long,
                              position.latitude,
                              position.longitude);
                          print(distance);
                          if (distance <= 100) {
                            Database_service(
                                    username: widget.username,
                                    adminname: widget.adminname)
                                .updateuserinfo(
                              user[index].data["password"],
                              !user[index].data["attendence"],
                              Insposition_lat,
                              Insposition_long,
                            );
                          } else {
                            final snackBar = SnackBar(
                              content:
                                  Text('please move closer to the institute'),
                              duration: const Duration(seconds: 3),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                      ),
                    );
                  }
                  return Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.brown[100],
                          ),
                          title: Text(user[index].data["username"]),
                          subtitle: Text(user[index].data["attendence"]
                              ? "present"
                              : "absent")));
                }),
          );
        });
  }
}
