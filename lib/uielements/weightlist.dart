import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/uielements/weightlistitem.dart';
Widget showWeightList(List<Weight> _weightList) {
    print(_weightList);
    if (_weightList.length > 0) {
      return new Column(
        children: [
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.fromLTRB(8, 20, 8, 8),
          itemBuilder: (context, index) {
            if(index==_weightList.length-1)
            return new WeightListItem(_weightList[index], 0) ;
            else
            return new WeightListItem(_weightList[index],_weightList[index].weight-_weightList[index+1].weight );
          },
          itemCount: _weightList.length,
        ))
      ],);
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 25.0),
      ));
    }
  }
