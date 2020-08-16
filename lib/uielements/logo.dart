import 'package:flutter/material.dart';
Widget showLogo(BuildContext context) {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset('assets/xing.png'),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "Weight Tracker",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30,color: Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      ),
    );
  }