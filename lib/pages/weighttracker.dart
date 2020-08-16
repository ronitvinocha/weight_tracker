
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/model/weightmodel.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/pages/root.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:weight_tracker/uielements/weightlistitem.dart';

import 'addweightdialog.dart';

class WeightTracker extends StatefulWidget{
  BaseAuth auth;
  WeightTracker({this.logoutcallback,this.auth});
  VoidCallback logoutcallback;
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
   return
     Consumer<WeightModel>(
       builder: (context,weighttrackker,child){
         if(weighttrackker.items.length!=0)
           {
              WidgetsBinding.instance.addPostFrameCallback((_) => scrolltotop());
           }
         return new Scaffold(
           body:new Container(
               decoration: BoxDecoration(color:Theme.of(context).primaryColor),
                child: weighttrackker.items.length==0?Center(child:Text("No weight input",style: TextStyle(color: Colors.white70,fontSize: 30))):new Column(
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
           floatingActionButton:  SizedBox(height: 40,width: 200,
                    child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                      color: Theme.of(context).accentColor,
                  child: Text("New Weight",style: TextStyle(fontFamily: 'roboto',fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                onPressed: (){
                    if(weighttrackker.items.length>0)
                    showAddWeightDialog(context,weighttrackker.items.first);
                    else
                    showAddWeightDialog(context,null);
                  },
                )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
           appBar: _createAppBar(context),
         );
          },


        );
       }
       void showAddWeightDialog(BuildContext context,Weight lastweight)async  {
        Weight weight=await Navigator.of(context).push(new MaterialPageRoute<Weight>(
            builder: (BuildContext context) {
              return  AddEntryDialog(
                  previousorlastweight: lastweight, iseditoperation: false);
            },
        ));
        if(weight!=null)
          {
            print("🐱${weight.weight}");
             Provider.of<WeightModel>(context).add(weight);
          }
        }
        Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: Text("Weight Inputs"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
       new FlatButton(
            onPressed: () {
              widget.logoutcallback();
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => new RootPage(
          auth: widget.auth)));
            },
            child: Icon(Icons.exit_to_app,color: Colors.white))

      ],
    );
  }
}



//