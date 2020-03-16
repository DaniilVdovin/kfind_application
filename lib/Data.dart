
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class Topic {
      String fullname, discription, price, imageUrl;
      Topic({this.fullname,this.discription,this.price,this.imageUrl});
 }
class Data {
  static SharedPreferences prefs;
  static String serverprefix = "http://localhost:15950/";

  static Topic topic;
}