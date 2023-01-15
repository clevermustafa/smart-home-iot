import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smarthom/provider/button_value_provider.dart';
import 'package:smarthom/services/local_data_sources.dart';
import 'package:smarthom/services/services.dart';
import 'package:smarthom/utils/enums.dart';
import 'package:smarthom/view/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Services network = Services();
  bool isLoading = false;
  bool isInitialLoading = false;
  // List<ButtonModel> buttons = [
  //   ButtonModel(
  //     buttonName: "Led",
  //   ),
  //   ButtonModel(
  //     buttonName: "ExtBoard",
  //   )
  // ];

  // late int led;
  // late int fan;
  // late int extBoard;
  // String? ledPin;
  // String? extPin;

  @override
  void initState() {
    super.initState();
    // getPins();
    getDataFromBlynk();
  }
  // getPins() async{
  //   ledPin = await LocalDataSource.getLedPin();
  //   extPin = await LocalDataSource.getExtBoardPin();
  // }

  getDataFromBlynk() async {
    setState(() {
      isInitialLoading = true;
    });
    // await Future.delayed(Duration(seconds: 1));
    final p = Provider.of<ButtonValueProvider>(context, listen: false);
    p.buttons[0].pin = await LocalDataSource.getLedPin();
    p.buttons[0].buttonValue = await network.getData(p.buttons[0].pin!);

    ///call getData api by passing led pin
    p.buttons[1].pin = await LocalDataSource.getFanPin();
    p.buttons[1].buttonValue = await network.getData(p.buttons[1].pin!);

    ///call getData api by passing led pin
    setState(() {
      isInitialLoading = false;
    });
  }

  upDateToBlynk(String pin, int value, int index) async {
    setState(() {
      isLoading = true;
    });
    await network.updateData(pin, value).then((value) {
      if (index == 0) {
        Provider.of<ButtonValueProvider>(context, listen: false)
            .getLedButtonValue();
      } else if (index == 1) {
        Provider.of<ButtonValueProvider>(context, listen: false)
            .getExtButtonValue();
      }
    });

    isLoading = false;
    setState(() {});
  }

  // String getStatus(int index) {
  //   if (index == 0) {
  //     if (led == 1) {
  //       return "On";
  //     } else {
  //       return "Off";
  //     }
  //   } else if (index == 1) {
  //     if (fan == 1) {
  //       return "On";
  //     } else {
  //       return "Off";
  //     }
  //   } else if (index == 2) {
  //     if (extBoard == 1) {
  //       return "On";
  //     } else {
  //       return "Off";
  //     }
  //   } else {
  //     return "";
  //   }
  // }

  // changeStatus(int index) {
  //   if (index == 0) {
  //     setState(() {
  //       led == 1 ? led = 0 : led = 1;
  //     });
  //   } else if (index == 1) {
  //     setState(() {
  //       extBoard == 1 ? extBoard = 0 : extBoard = 1;
  //     });
  //   } else if (index == 2) {
  //     setState(() {
  //       // fan == 1 ? fan = 0 : fan = 1;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final pLisneable = Provider.of<ButtonValueProvider>(context);
    final p = Provider.of<ButtonValueProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          "Smart Home",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getDataFromBlynk();
        },
        child: Stack(
          children: [
            isInitialLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: p.buttons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          upDateToBlynk(
                            p.buttons[index].pin!,
                            p.buttons[index].buttonValue == 1 ? 0 : 1,
                            index,
                          );
                        },
                        child: Card(
                          color: pLisneable.buttons[index].buttonValue == 1
                              ? Colors.deepPurple
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Text(
                                  p.buttons[index].buttonName!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: p.buttons[index].buttonValue == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Switch(
                                          value:
                                              p.buttons[index].buttonValue == 1
                                                  ? true
                                                  : false,
                                          activeColor: Colors.white,
                                          onChanged: (val) {
                                            upDateToBlynk(
                                              p.buttons[index].pin!,
                                              p.buttons[index].buttonValue == 1
                                                  ? 0
                                                  : 1,
                                              index,
                                            );
                                          }),
                                      Text(
                                        // getStatus(index).toString(),
                                        pLisneable.buttons[index].buttonValue ==
                                                1
                                            ? "ON"
                                            : "Off",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: pLisneable.buttons[index]
                                                      .buttonValue ==
                                                  1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class ButtonModel {
  String? buttonName;
  String? pin;
  int buttonValue;
  ButtonModel({this.buttonName, this.pin, this.buttonValue = 1});

  ButtonModel copyWith({
    String? buttonName,
    String? pin,
    int? buttonValue,
  }) {
    return ButtonModel(
        buttonName: buttonName ?? this.buttonName,
        pin: pin ?? this.pin,
        buttonValue: buttonValue ?? this.buttonValue);
  }
}
