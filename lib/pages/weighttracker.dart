import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/model/weightmodel.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/uielements/weightlist.dart';
import 'package:weight_tracker/uielements/weightlistitem.dart';

import 'addweightdialog.dart';

class WeightTracker extends StatefulWidget{
  WeightTracker({this.userid});
  final String userid;
  @override
  State<StatefulWidget> createState() => new _WeightTrackerPageState();
}
class _WeightTrackerPageState extends State<WeightTracker>
{
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController=ScrollController();
  }
  void scrolltotop()
  {
    scrollController.jumpTo(0);
  }
  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) => scrolltotop());
   return
     Consumer<WeightModel>(
       builder: (context,weighttrackker,child){
         return new Scaffold(
           body:new Container(
        decoration: BoxDecoration(color: Colors.black),
        child: new Column(
        children: [
        new Flexible(
            child: new ListView.builder(
           physics: const AlwaysScrollableScrollPhysics (),
          controller: scrollController,
          padding: new EdgeInsets.fromLTRB(0, 20, 0, 8),
          itemBuilder: (context, index) {
            if(index==weighttrackker.items.length-1)
            return new WeightListItem(weight: weighttrackker.items[index], weightDifference: 0) ;
            else
            return new WeightListItem(weight:weighttrackker.items[index],weightDifference:weighttrackker.items[index].weight-weighttrackker.items[index+1].weight );
          },
          itemCount: weighttrackker.items.length,
        ))
      ],)
      ),
           floatingActionButton: Container(
                decoration: new BoxDecoration(color: Theme.of(context).accentColor.withOpacity(0.75),borderRadius: BorderRadius.all(Radius.circular(50)),),
                width: 200.0,
                height: 50.0,
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  elevation: 0.0,
                  child: Text("New Weight",style: TextStyle(fontFamily: 'roboto',fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                onPressed: (){
                    if(weighttrackker.items.length>0)
                    showAddWeightDialog(context,weighttrackker.items.first);
                    else
                    showAddWeightDialog(context,null);
                  },
                )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
         );
          },


        );
       }
}

Future showAddWeightDialog(BuildContext context,Weight lastweight) async {
   Weight weight= await Navigator.of(context).push(new MaterialPageRoute<Weight>(
      builder: (BuildContext context) {
        return new AddEntryDialog(previousorlastweight: lastweight,iseditoperation: false);
      },
    fullscreenDialog: true
  ));
  if(weight!=null)
    {
      print("🐱${weight.weight}");
       Provider.of<WeightModel>(context).add(weight);
    }
  }

//