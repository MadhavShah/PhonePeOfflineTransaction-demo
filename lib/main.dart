import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';
import 'ui/splashscreen.dart';
import 'ui/phonepe.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool popup = true;
  Future<bool> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String senderName = prefs.getString('sender');
    print(senderName);
    if(senderName != null){
      setState(() {
        popup = false;
      });
    }
  }
  @override
  void initState() {
    getName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Colors.blue[800],
      ),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        PHONE_PE: (BuildContext context) => FlutterDevs(popup),

      },
    );
  }
}