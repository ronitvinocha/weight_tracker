import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/root.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:  Color(0xFF111122), // navigation bar color
    statusBarColor:  Color(0xFF111122), // status bar color
  ));
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF111122),
        secondaryHeaderColor: Color(0xFF18182A),
        accentColor: Color(0xFF29FFCB),
        splashColor: Colors.white70,
        fontFamily: "roboto",
        textTheme: TextTheme(caption: TextStyle(color: Colors.white))
      ),
      debugShowCheckedModeBanner: false,
      home: new RootPage(auth:new Auth())
    );
  }
}