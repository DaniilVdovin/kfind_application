import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kfons_search/pages/Userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import '../Data.dart';
import 'Userpage.dart';

class Mainmapscreen extends StatefulWidget {
  @override
  MainmapscreenStage createState() => MainmapscreenStage();
}
void _loadTopicData(){
  Data.topic = Topic(
  fullname:"Mike Marelo",
  discription: "Lost aroun KFC рядом видели бабушку",
  price: "1.000.000.000P", 
  imageUrl:Data.serverprefix + "api/getImage?token="+Data.token+"&file=def.png");
}

class MainmapscreenStage extends State<Mainmapscreen> {
    void _loadMe() async {
     await http.get(Data.serverprefix+'api/getme?token='+Data.token)
        .then((response){
          Map<String,dynamic> js = json.decode(utf8.decode(response.bodyBytes));
          Data.user = User(
            id:       js["id"],
            fullname: js["fullname"],
            login:    js["login"],
            location: js["location"],
            verified: js["verified"],
            searches: js["searches"],
            avatar:   js["avatar"]
            );
          setState(() {
            Toast.show("r:"+utf8.decode(response.bodyBytes), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          });
        });
    }

  @override
  void initState() {
    super.initState();
    _loadTopicData();
    _loadMe();
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
    final profButton = FloatingActionButton(
      elevation: 2.0,
      onPressed: (){
        Navigator.push(context,
        MaterialPageRoute(builder:  (context)=> Userpage()));
      },
      child: Icon(Icons.person_outline,size: 30.0,),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black54,
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: profButton,
                        ),
                      ),
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
    LatLng _center = LatLng(Data.city.coordinats[0], Data.city.coordinats[1]);
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