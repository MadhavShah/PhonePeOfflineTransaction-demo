import 'package:flutter/material.dart';

import 'Constant.dart';
import 'ui/splashscreen.dart';
import 'ui/phonepe.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Colors.blue[800],
      ),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        PHONE_PE: (BuildContext context) => FlutterDevs(),

      },
    );
  }
}