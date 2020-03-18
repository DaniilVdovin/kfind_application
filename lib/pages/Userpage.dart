import 'dart:convert';

import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Data.dart';
import 'Mainmapscreen.dart';
import 'map.dart';

class Userpage extends StatefulWidget {
  @override
  UserpageState createState() => UserpageState();
}

class UserpageState extends State<Userpage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    TextStyle tistleStyle = bodyStyle.copyWith(fontSize: 30.0);

    Widget _getBox(List<Widget> children) {
      return Material(
        elevation: 1.0,
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
            margin: const EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: Row(
                      children: <Widget>[
                        BackButton(
                          color: Colors.black54,
                        ),
                        SizedBox(width: 75.0),
                        Text("Profile",
                            style: tistleStyle.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Material(
                    borderRadius: BorderRadius.circular(60.0),
                    elevation: 6.0,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          Data.serverprefix+"api/getImage?token="+Data.token+"&file="+Data.user.avatar),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _getBox([
                    Text("Full Name: " + Data.user.fullname,
                        style: tistleStyle.copyWith(
                            color: Colors.black54,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    Text("Login: " + Data.user.login,
                        style: tistleStyle.copyWith(
                            color: Colors.black54,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    Text("Location: " + Data.user.location,
                        style: tistleStyle.copyWith(
                            color: Colors.black54,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    Text("User Id: " + Data.user.id.toString(),
                        style: tistleStyle.copyWith(
                            color: Colors.black54,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 10.0),
                  //singUpButon,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
