import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/model/weightmodel.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:weight_tracker/pages/login.dart';
import 'package:weight_tracker/uielements/logo.dart';
import 'package:weight_tracker/pages/weighttracker.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool firstimelogin=true;
  @override
  void initState() {
    super.initState();
  }
  void getcurrentuser(BuildContext context) async
  {
    if(firstimelogin)
      {
        widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          print(user?.uid);
          _userId = user?.uid;
          if (_userId.length > 0 && _userId != null) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
              new ChangeNotifierProvider<WeightModel>(builder: (context) => WeightModel(_userId),
              child: new WeightTracker())
              ),(Route<dynamic> route) => false);
          }
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback)));
          }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
      firstimelogin=false;
      }
  }
  void loginCallback(String userid) {
    firstimelogin=true;
    getcurrentuser(context);
  }
  void gotomain()
  {
     if (_userId.length > 0 && _userId != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
              new ChangeNotifierProvider<WeightModel>(builder: (context) => WeightModel(_userId),
              child: new WeightTracker())
              ));
          }
  }
  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }



  @override
  Widget build(BuildContext context) {
  getcurrentuser(context);
  return Scaffold(
     body:  Container(
             height: double.infinity,
             width: double.infinity,
             decoration: BoxDecoration(color: Theme.of(context).primaryColor),
             child: Center(child: Container(
               width: 50,
               height: 50,
               child: CircularProgressIndicator(backgroundColor: Colors.white70,valueColor: new AlwaysStoppedAnimation<Color>(Colors.tealAccent),
             ),)
          ),)
        );
  }
}