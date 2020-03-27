import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Data.dart';
import 'Mainmapscreen.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  List<City> districts = [];
  bool _selected = false;
  void _loadListOfDistrict() async {
    await http
        .get(Data.serverprefix + 'api/getLocations')
        .then(_proccesingLocation);
  }

  void _proccesingLocation(http.Response response) {
    Map<String, dynamic> map =
        json.decode(utf8.decode(response.bodyBytes))["districts"];
    map.forEach((k, v) {
      if (k != null) districts.add(City(name: k, coordinats: v));
    });
    setState(() {});
  }

  void _postLocation() async {
    await http.post(Data.serverprefix +
        'api/setLocation?location=' +
        Data.city.name +
        "&token=" +
        Data.token);
    _saveCity();
  }

  void _saveCity() {
    Data.prefs.setString("location.name", Data.city.name);
    Data.prefs.setDouble("location.lat", Data.city.coordinats[0]);
    Data.prefs.setDouble("location.lon", Data.city.coordinats[1]);
  }

  @override
  void initState() {
    super.initState();
    _loadListOfDistrict();
    if (Data.prefs.getString("location.") != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Mainmapscreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final cypPicker = Expanded(
        child: Material(
            child: ListView.builder(
                itemExtent: 48.0,
                itemCount: districts.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, item) {
                  final c = districts[item];
                  return ListTile(
                    title: Text(c.name,
                        style: bodyStyle.copyWith(fontWeight: FontWeight.w400)),
                    onTap: () {
                      setState(() {
                        Data.city = c;
                        _selected = true;
                      });
                    },
                  );
                })));
    final searchDistrict = TextField(
      obscureText: false,
      enabled: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: Data.city.name,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
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
              Material(
                animationDuration: Duration(seconds: 1),
                elevation: 5.0,
                borderRadius: BorderRadius.circular(15.0),
                color: _selected ? Color(0xff01A0C7) : Colors.grey,
                child: AbsorbPointer(
                  absorbing: !_selected,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Mainmapscreen()));
                      _postLocation();
                    },
                    child: Text("Next",
                        textAlign: TextAlign.center,
                        style: bodyStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
