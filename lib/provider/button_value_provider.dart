

import 'package:flutter/material.dart';
import 'package:smarthom/services/local_data_sources.dart';
import 'package:smarthom/services/services.dart';

import '../view/home_page.dart';

class ButtonValueProvider with ChangeNotifier{
  // bool isLoading = false;
  Services network = Services();
  List<ButtonModel> buttons = [
    ButtonModel(
      buttonName: "Led",
    ),
    ButtonModel(
      buttonName: "Fan",
    )
  ];

  Future<void> getLedButtonValue() async{
    final pin = await LocalDataSource.getLedPin();
    buttons[0].buttonValue = await network.getData(pin);
    notifyListeners();
  }
  Future<void> getExtButtonValue() async{
    final pin = await LocalDataSource.getExtBoardPin();
    buttons[1].buttonValue = await network.getData(pin);
    notifyListeners();
  }
}