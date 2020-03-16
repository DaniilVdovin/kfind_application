import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Data.dart';
import 'Mainmapscreen.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  String curennt_city = "Сочи";
  
  SharedPreferences prefs;
  List<String> districts = new List();
  Future<bool> _loadprefs() async {
        prefs = await SharedPreferences.getInstance();
        if(prefs!=null) 
         return true;
        return false;
    }
  void _loadListOfDistrict() async {
      await http.get(Data.serverprefix+'api/getLocations')
          .then(_proccesingLocation);
  }
  void _proccesingLocation(http.Response response){
      var map = json.decode(utf8.decode(response.bodyBytes))["districts"];
      map.forEach((v){
        if(v!=null)
          districts.add(v);
      });
      setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _loadprefs();
    _loadListOfDistrict();
   }
    
  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    TextStyle tistleStyle = bodyStyle.copyWith(fontSize: 30.0);

    final cypPicker =Expanded(
      child: Material(
      child: ListView.builder(
        itemExtent: 48.0,
        itemCount: districts.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,item){
        final text = districts[item];
          return ListTile(
            title: Text(text,style: bodyStyle.copyWith(fontWeight: FontWeight.w400)),
            onTap: (){
            setState(() {
                curennt_city = text;
            });
            },
         );
        }
      )));
    final searchDistrict = TextField(
          obscureText: false,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: curennt_city,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
    final nextButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Mainmapscreen()));
                Data.prefs.setString("location", curennt_city);
            },
            child: Text("Next",
                textAlign: TextAlign.center,
                style: bodyStyle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            ),   
        );
    return Scaffold(
          body: SafeArea(
                      child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    searchDistrict,
                    cypPicker,
                    nextButton,
                  ],
                ),
              ),
            ),
          ) 
        );
  }
}
