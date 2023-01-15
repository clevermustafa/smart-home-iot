import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthom/main.dart';
import 'package:smarthom/provider/button_value_provider.dart';
import 'package:smarthom/services/local_data_sources.dart';
import 'package:smarthom/services/services.dart';
import 'package:smarthom/utils/enums.dart';
import 'package:smarthom/utils/toast_utils.dart';
import 'package:smarthom/view/set_info_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/smart_home.png",
              fit: BoxFit.contain, width: double.infinity, height: 200),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SetLedIntervalPage()));
                    },
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Set Custom Time",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SetInfoPage()));
                    },
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Set Device Info"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SetLedIntervalPage extends StatefulWidget {
  const SetLedIntervalPage({super.key});

  @override
  State<SetLedIntervalPage> createState() => _SetLedIntervalPageState();
}

class _SetLedIntervalPageState extends State<SetLedIntervalPage> {
  TimeOfDay? selectedLedStartTime;
  TimeOfDay? selectedExtStartTime;
  // TimeOfDay? selectedOffTime;
  Services network = Services();
  int ledOperation = 1;
  int extOperation = 1;
  startTimer(TimeOfDay time, String pin, int value) async {
    print("method called");
    bool disableOnApiCall = false;

    Timer.periodic(const Duration(seconds: 1), (t) {
      print("running");
      TimeOfDay nowTime = TimeOfDay.now();
      double now = toDouble(nowTime);
      double selectedOn = toDouble(time);
      if (now >= selectedOn) {
        if (disableOnApiCall == false) {
          //call on Api
          print("on");
          network.updateData(pin, value).then((value) {
            disableOnApiCall = true;
            t.cancel();

            Provider.of<ButtonValueProvider>(navigatorKey.currentState!.context,
                    listen: false)
                .getLedButtonValue();
            Provider.of<ButtonValueProvider>(navigatorKey.currentState!.context,
                    listen: false)
                .getExtButtonValue();
          });
        }
      }
      // double selectedOff = toDouble(selectedOffTime!);
      // print("now: $now");
      // print("selectedOn: $selectedOn");
      // print("selectedOff: $selectedOff");
      // if (now >= selectedOn) {
      //   if (disableOnApiCall == false) {
      //     //call on Api
      //     print("on");
      //     network.updateData("V0", 1);
      //     disableOnApiCall = true;
      //   }
      // }
      // selectedOff
      // if (now >= selectedOff) {
      //   if (disableOffApiCall == false) {
      //     //call the api
      //     print("off");
      //     network.updateData("V0", 0);
      //     disableOffApiCall = true;
      //     t.cancel();
      //   }
      // }
    });
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Custom Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LED",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                selectedLedStartTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {});
                              },
                              child: const Text("Start At :"),
                            ),
                            Text(selectedLedStartTime == null
                                ? ""
                                : selectedLedStartTime!.format(context))
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                selectedLedStartTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {});
                              },
                              child: const Text("Value"),
                            ),
                            DropdownButton<String>(
                              value: ledOperation == 1 ? "On" : "Off",
                              items: ["On", "Off"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  ledOperation = ledOperation == 0 ? 1 : 0;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (selectedLedStartTime != null) {
                            LocalDataSource.getLedPin().then((value) {
                              startTimer(
                                  selectedLedStartTime!, value, ledOperation);

                              Navigator.pop(context);
                            });
                          } else {
                            ToastUtils.showToast(
                                "Please Select Time", ToastType.error);
                          }
                        },
                        child: const Text("Confirm"))
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                selectedExtStartTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {});
                              },
                              child: const Text("Start At :"),
                            ),
                            Text(selectedExtStartTime == null
                                ? ""
                                : selectedExtStartTime!.format(context))
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                selectedExtStartTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {});
                              },
                              child: const Text("Value"),
                            ),
                            DropdownButton<String>(
                              value: extOperation == 1 ? "On" : "Off",
                              items: ["On", "Off"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  extOperation = extOperation == 0 ? 1 : 0;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedExtStartTime != null) {
                          LocalDataSource.getExtBoardPin().then(
                            (value) {
                              startTimer(
                                selectedExtStartTime!,
                                value,
                                extOperation,
                              );
                            },
                          );

                          Navigator.pop(context);
                        } else {
                          ToastUtils.showToast(
                              "Please Select Time", ToastType.error);
                        }
                      },
                      child: const Text("Confirm"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
