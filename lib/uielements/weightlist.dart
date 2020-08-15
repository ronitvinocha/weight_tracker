import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/uielements/weightlistitem.dart';
Widget showWeightList(List<Weight> _weightList) {
    for(Weight weight in _weightList)
      {
        print("🥑${weight.weight}");
      }
    if (_weightList.length > 0) {
      return null;

    } else {
      return Center(
          child: Text(
        "Add a weight",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 25.0),
      ));
    }
  }
