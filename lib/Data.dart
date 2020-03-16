
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class Topic {
  String fullname, discription, price, imageUrl;
  Topic({this.fullname,this.discription,this.price,this.imageUrl});
 }
class City{
  String name;
  dynamic coordinats;
  City({this.name,this.coordinats});
}
class Data {
  static SharedPreferences prefs;
  static String serverprefix = "http://localhost:15950/";

  static City city = City(name:"Адлер",coordinats: [43.5832281,39.991644]);
  static Topic topic;
}