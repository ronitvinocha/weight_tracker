import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/root.dart';
import 'package:weight_tracker/services/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth:new Auth())
    );
  }
}