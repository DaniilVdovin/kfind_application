import 'package:shared_preferences/shared_preferences.dart';

class Data {
  static SharedPreferences prefs;
  static String userToken = prefs.getString("token");
  static String serverprefix = "http://192.168.1.3:15950/";
}