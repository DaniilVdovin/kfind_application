import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import '../Data.dart';
import 'Mainmapscreen.dart';
import 'map.dart';

class Startsearch extends StatefulWidget {
  @override
  StartsearchState createState() => StartsearchState();
}

class StartsearchState extends State<Startsearch> {
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

    Widget _getEntered(String hint) {
      return TextField(
        obscureText: false,
        style: bodyStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
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
                        SizedBox(width: 55.0),
                        Text("Start search",
                            style: tistleStyle.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _getBox([
                    MaterialButton(
                      height: 320.0,
                      onPressed: null,
                      child: Image(image: AssetImage('def.png')),
                    )
                  ]),
                  SizedBox(height: 10.0),
                  _getBox([
                    _getEntered("Full name"),
                    SizedBox(height: 10.0),
                    _getEntered("Remuneration"),
                  ]),
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
