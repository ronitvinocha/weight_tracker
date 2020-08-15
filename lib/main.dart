import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/root.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF335C81),
        accentColor: Colors.tealAccent,
        splashColor: Color(0xFF3BB273),
        fontFamily: "roboto",
        textTheme: TextTheme(caption: TextStyle(color: Colors.white))
      ),
      debugShowCheckedModeBanner: false,
      home: new RootPage(auth:new Auth())
    );
  }
}