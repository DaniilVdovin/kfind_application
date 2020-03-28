import 'dart:async';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../Data.dart';

class Startsearch extends StatefulWidget {
  @override
  StartsearchState createState() => StartsearchState();
}

class StartsearchState extends State<Startsearch> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      sendImage();
    });
  }
  Future sendImage() async {
      http.MultipartRequest('POST',Uri.parse(Data.serverprefix+"api/upload"))
      ..headers["token"]=Data.token
      ..files.add(await http.MultipartFile.fromPath("storage",_image.path,filename: "searches_"+Data.token+".jpg"))
      ..send();
  }
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

    Completer<GoogleMapController> _controller = Completer();
    LatLng _center = LatLng(Data.city.coordinats[0], Data.city.coordinats[1]);
    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    final map = GoogleMap(
      mapType: MapType.hybrid,
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Start search",
            style: tistleStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(scrollDirection: Axis.vertical, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MaterialButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      onPressed: getImage,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(image: AssetImage('def.png'))),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _getBox([
                      _getEntered("Full name"),
                      SizedBox(height: 10.0),
                      _getEntered("Remuneration"),
                      SizedBox(height: 15.0),
                      Container(
                        height: 140.0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: map),
                      ),
                      SizedBox(height: 25.0),
                      Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.redAccent,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text("Help me find !",
                                textAlign: TextAlign.center,
                                style: bodyStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ))
                    ]),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
