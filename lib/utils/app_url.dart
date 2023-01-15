import 'package:smarthom/services/local_data_sources.dart';

class AppUrl {
  static late String _token;
  static Future<void> setToken() async {
    _token = await LocalDataSource.getToken();
  }

  static String baseUrl = "https://sgp1.blynk.cloud/external/api/";
  static String isHardwareConnected = "isHardwareConnected?token=$_token";
  static String updateData = "update?token=$_token&";
  static String getData = "get?token=$_token&";
}
