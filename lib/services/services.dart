import 'dart:convert';
import 'dart:io';

import 'package:smarthom/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:smarthom/utils/toast_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class Services {
  Future<bool> updateData(String pin, int value) async {
    final url = Uri.parse("${AppUrl.baseUrl}${AppUrl.updateData}$pin=$value");
    try {
      final response = await http.get(url);
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("response: ${response.body}");
        print("success");
        return true;
      } else {
        print("fail");
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getData(String pin) async {
    final url = Uri.parse("${AppUrl.baseUrl}${AppUrl.getData}$pin");
    print(url);
    try {
     
      final response = await http.get(url);
      if (response.statusCode == 200) {
        
        final int decodedData = jsonDecode(response.body);
        print("decodedData: $decodedData");
        return decodedData;
      } else {
        print("response.statusCode: ${response.statusCode}");
        print("response.request!.url: ${response.request!.url}");
        ToastUtils.showToast("Error", ToastType.error);
        throw "e";
      }
    } catch (e) {
      ToastUtils.showToast(e.toString(), ToastType.error);
      rethrow;
    }
  }
}
