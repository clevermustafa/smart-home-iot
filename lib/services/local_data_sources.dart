import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  
  static late SharedPreferences _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
  static Future<void> setToken(String value) async{
    await _prefs.setString(token, value);
  }
  static Future<String> getToken() async{
    return _prefs.getString(token)?? "";
  }
  static Future<void> setLedPin(String value) async{
     await _prefs.setString(led, value);
  }
  static Future<void> setFanPin(String value) async{
     await _prefs.setString(fan, value);
  }
  static Future<void> setExtBoardPin(String value) async{
     await _prefs.setString(extBoard, value);
  }

  static Future<String> getLedPin() async{
    return _prefs.getString(led)?? "";
  }
  static Future<String> getFanPin() async{
    return _prefs.getString(fan)?? "";
  }
  static Future<String> getExtBoardPin() async{
    return _prefs.getString(extBoard)?? "";
  }

}
String token = "TOKEN";
String led = "LED";
String fan = "FAN";
String extBoard = "EXTBOARD";
