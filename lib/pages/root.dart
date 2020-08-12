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
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }
  void getcurrentuser()
  {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          print(user?.uid);
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }
  void loginCallback() {
    print("🐹");
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [showLogo(),
        new Container(
          margin: const EdgeInsets.only(top: 10.0),
          child:  Text(
          'Weight Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'roboto',fontSize: 20),
        ),
        )
       ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return ChangeNotifierProvider<WeightModel>(
            builder: (context) => WeightModel(_userId),
            child: new WeightTracker()
        );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}