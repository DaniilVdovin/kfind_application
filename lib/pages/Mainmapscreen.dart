import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Data.dart';

class Mainmapscreen extends StatefulWidget {
  @override
  MainmapscreenStage createState() => MainmapscreenStage();
}

class MainmapscreenStage extends State<Mainmapscreen> {
  @override
  void initState() {
    super.initState();
   }
    
  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    TextStyle tistleStyle = bodyStyle.copyWith(fontSize: 30.0);

    final hmfButton = Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: null,
            child: Text("Help me find !",
                textAlign: TextAlign.center,
                style: bodyStyle.copyWith(
                    color: Colors.black45, fontWeight: FontWeight.bold)),
            ),   
        );
    final ui = SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 65.0),
                          child: hmfButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    
    Completer<GoogleMapController> _controller = Completer();
    const LatLng _center = const LatLng(45.521563, -122.677433);
    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }
    final map = GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ));
    return Scaffold(
          body: Stack(
                      children:[
                        map,
                        ui,
                      ]) 
        );
  }
}