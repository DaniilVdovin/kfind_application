import 'dart:convert';

import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../Data.dart';
import 'Mainmapscreen.dart';
import 'map.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class RegistrPage extends StatefulWidget {
  @override
  RegistPageState createState() => RegistPageState();
}

class RegistPageState extends State<RegistrPage>
    with SingleTickerProviderStateMixin {
  Future<bool> _loadprefs() async {
    Data.prefs = await SharedPreferences.getInstance();
    if (Data.prefs.getString("token") != null &&
        Data.prefs.getString("token") != "") {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mainmapscreen()),
        );
        Data.token = Data.prefs.getString("token");
      });
      return true;
    }
    return false;
  }

  AnimationController controller;
  final fullnameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController();

  Future<http.Response> reg(
      String login, String password, String fullname) async {
    return await http.get(Data.serverprefix +
        'api/register?login=' +
        login +
        '&password=' +
        password +
        "&fullname=" +
        fullname);
  }

  void _registrarion() {
    String token;
    if (fullnameController.text.length > 0) {
      reg(emailController.text, passwordController.text,
              fullnameController.text)
          .then((js) {
        if ((token = json.decode(js.body)["token"]) != null)
          Toast.show("l" + token, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage()),
          );
          Data.prefs.setString("token", token);
          Data.token = token;
        });
      });
    } else {
      setState(() {
        Toast.show("Please enter", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });
    }
  }

  void _login() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadprefs();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    TextStyle tistleStyle = bodyStyle.copyWith(fontSize: 30.0);

    final emailField = TextField(
      obscureText: false,
      style: bodyStyle,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Login",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final fullNameField = TextField(
      key: Key("kFullname"),
      obscureText: false,
      style: bodyStyle,
      controller: fullnameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: bodyStyle,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final singUpButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _registrarion,
        child: Text("Singn Up",
            textAlign: TextAlign.center,
            style: bodyStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final singInButon = Material(
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        onPressed: _login,
        child: Text("Singn In",
            textAlign: TextAlign.center,
            style: bodyStyle.copyWith(
                color: Color(0xff01A0C7),
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("People Search",
                    style: tistleStyle.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(height: 35.0),
                fullNameField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 35.0),
                singUpButon,
                SizedBox(height: 15.0),
                singInButon,
                SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(),
      passwordController = TextEditingController();
  Future<http.Response> reg(String login, String password) async {
    return await http.get(Data.serverprefix +
        'api/login?login=' +
        login +
        '&password=' +
        password);
  }

  void _registrarion() {
    String token;
    if (emailController.text.length > 0) {
      reg(emailController.text, passwordController.text).then((text) {
        Toast.show("t:" + text.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if ((token = json.decode(text.body)["token"]) != null)
        Data.prefs.setString("token", token);
        Data.token = token;
          setState(() {
            Toast.show("t:" + token, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
          });
      });
    } else {
      setState(() {
        Toast.show("Please enter", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (Data.prefs.getString("token") != null &&
        Data.prefs.getString("token") != "") {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mainmapscreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    TextStyle tistleStyle = bodyStyle.copyWith(fontSize: 30.0);

    final emailField = TextField(
      obscureText: false,
      style: bodyStyle,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "login",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: bodyStyle,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final singUpButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _registrarion,
        child: Text("Singn In",
            textAlign: TextAlign.center,
            style: bodyStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("People Search",
                    style: tistleStyle.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 35.0),
                singUpButon,
                SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
