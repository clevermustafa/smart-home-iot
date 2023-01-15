import 'package:flutter/material.dart';
import 'package:smarthom/services/local_data_sources.dart';
import 'package:smarthom/utils/app_url.dart';
import 'package:smarthom/utils/constants.dart';
import 'package:smarthom/utils/toast_utils.dart';
import 'package:smarthom/view/home_page.dart';

class SetInfoPage extends StatefulWidget {
  const SetInfoPage({super.key});

  @override
  State<SetInfoPage> createState() => _SetInfoPageState();
}

class _SetInfoPageState extends State<SetInfoPage> {
  final TextEditingController _tokenController = TextEditingController();
  String _selectedLedPin = "V0";
  String _selectedFanPin = "V1";
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    _tokenController.text = await LocalDataSource.getToken();
    final tempFanPin = await LocalDataSource.getFanPin();
    final tempLedPin = await LocalDataSource.getLedPin();
    _selectedLedPin = tempFanPin == "" ? "V1" : tempFanPin;
    _selectedFanPin = tempLedPin == "" ? "V0" : tempLedPin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Set Device Token",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _tokenController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Set Led pin"),
                DropdownButton<String>(
                  value: _selectedLedPin,
                  items: pins.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLedPin = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Set Fan pin"),
                DropdownButton<String>(
                  value: _selectedFanPin,
                  items: pins.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFanPin = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (_tokenController.text.isNotEmpty &&
                    _selectedLedPin.isNotEmpty &&
                    _selectedFanPin.isNotEmpty) {
                  await Future.wait([
                    LocalDataSource.setFanPin(_selectedFanPin),
                    LocalDataSource.setLedPin(_selectedLedPin),
                    LocalDataSource.setToken(_tokenController.text),
                    AppUrl.setToken(),
                  ]).then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage())));
                } else {
                  ToastUtils.showToast(
                      "Please set values before continuing", ToastType.error);
                }
              },
              child: Text("Save Value"),
            )
            // const Text("Set Led pin"),
            // TextField(
            //   controller: _ledController,
            // ),
            // const Text("Set Fan Token"),
            // TextField(
            //   controller: _fanController,
            // ),
            // const Text("Set ExtBoard Token"),
            // TextField(
            //   controller: _extBoardController,
            // ),
          ],
        ),
      ),
    );
  }
}
