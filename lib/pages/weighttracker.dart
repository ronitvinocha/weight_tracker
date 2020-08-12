import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/model/weightmodel.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/uielements/weightlist.dart';

import 'addweightdialog.dart';

class WeightTracker extends StatefulWidget{
  WeightTracker({this.userid});
  final String userid;
  @override
  State<StatefulWidget> createState() => new _WeightTrackerPageState();
}
class _WeightTrackerPageState extends State<WeightTracker>
{
  TextEditingController _textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
   return
     Consumer<WeightModel>(
       builder: (context,weighttrackker,child){
         return new Scaffold(
           body: showWeightList(weighttrackker.items),
           floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(weighttrackker.items.length>0)
            showAddWeightDialog(context,weighttrackker.items.first.weight);
            else
            showAddWeightDialog(context,0);
          },
             tooltip: 'Increment',
              child: Icon(Icons.add),
          ));
          },


        );
       }
}

Future showAddWeightDialog(BuildContext context,double lastweight) async {
   Weight weight= await Navigator.of(context).push(new MaterialPageRoute<Weight>(
      builder: (BuildContext context) {
        return new AddEntryDialog(initialweight: lastweight);
      },
    fullscreenDialog: true
  ));
  if(weight!=null)
    {
       Provider.of<WeightModel>(context).add(weight);
    }
  }

//