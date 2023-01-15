import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthom/provider/button_value_provider.dart';
import 'package:smarthom/services/local_data_sources.dart';
import 'package:smarthom/utils/app_url.dart';
import 'package:smarthom/view/home_page.dart';
import 'package:smarthom/view/set_info_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDataSource.init();
  AppUrl.setToken();
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ButtonValueProvider(),
      child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Smart Home',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.deepPurple,
          ),
          home: const NavigationPage()),
    );
  }
}

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: LocalDataSource.getToken(),
          builder: (ctx, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (s.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else if (s.hasData) {
              String token = s.data as String;
              if (token.isEmpty) {
                return const SetInfoPage();
              } else {
                return const HomePage();
              }
            }
            return Container();
          }),
    );
  }
}
