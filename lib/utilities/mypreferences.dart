import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  final String auth_token = "auth_token";
  final String uuid_token = "uuid_token";

//set data into shared preferences like this
  Future<void> setAuthToken(String authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(auth_token, authToken);
  }

//get value from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? authToken;
    authToken = pref.getString(auth_token);
    return authToken;
  }

  //set data into shared preferences like this
  Future<void> setUUIDToken(String uuidtoken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uuid_token, uuidtoken);
  }

//get value from shared preferences
  Future<String?> getUUIDToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? uuidToken;
    uuidToken = pref.getString(uuid_token);
    return uuidToken;
  }
}
