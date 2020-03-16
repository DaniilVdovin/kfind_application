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
void _loadTopicData(){
  Data.topic = Topic(
  fullname:"Mike Marelo",
  discription: "Lost aroun KFC рядом видели бабушку",
  price: "1.000.000.000P", 
  imageUrl:"https://sun1-25.userapi.com/impf/c856024/v856024912/aed20/9p-I4SjGNWA.jpg?size=400x0&quality=90&sign=038e917ccb4ce61c249f4ab191517305");
}
class MainmapscreenStage extends State<Mainmapscreen> {
  @override
  void initState() {
    super.initState();
     _loadTopicData();
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
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: null,
            child: Text("Help me find !",
                textAlign: TextAlign.center,
                style: bodyStyle.copyWith(
                    color: Colors.black45, fontWeight: FontWeight.bold)),
            ),   
        );
    final nawcard = SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: 
              Container(
                height: MediaQuery.of(context).size.height*0.135,
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         ClipRRect(
                         borderRadius: BorderRadius.circular(15.0),
                         child: Image.network(
                         Data.topic.imageUrl,
                         width: 100,
                         height: 100,
                         ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Stack(
                              overflow: Overflow.visible,
                              children:[Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Data.topic.fullname,style: tistleStyle.copyWith(fontWeight: FontWeight.w800,fontSize: 18.0)),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: Text(Data.topic.discription,style: bodyStyle.copyWith(fontSize: 16.0) ,textAlign: TextAlign.left),
                                ),
                              ],
                            ),
                             Align(alignment: Alignment.bottomRight,
                               child: Text(Data.topic.price,
                               style: tistleStyle.copyWith(color: Colors.black54,fontWeight: FontWeight.w800,fontSize: 18.0)))]),
                        )
                      ],
                    ),
                  )
          ),
              ),
        ));
    final ui = SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(alignment: Alignment.bottomRight,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 65.0),
                          child: hmfButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    
    Completer<GoogleMapController> _controller = Completer();
    const LatLng _center = const LatLng(43.4393335,39.9026883);
    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    final map = GoogleMap(
          onMapCreated: _onMapCreated,   
         initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ));

    return Scaffold(
          body: Stack(children:[
                        map,
                        ui,
                        nawcard,
                      ]) 
        );
  }
}