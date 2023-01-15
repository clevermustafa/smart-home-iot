import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ToastUtils {
  static showToast(String msg, ToastType toastType) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: getToastColor(toastType),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static getToastColor(ToastType toastType) {
    switch (toastType) {
      case ToastType.success:
        return Colors.green;

      case ToastType.error:
        return Colors.red;
    }
  }
}

enum ToastType { success, error }


