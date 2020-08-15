import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/model/weightmodel.dart';
import 'package:weight_tracker/pages/addweightdialog.dart';
class WeightListItem extends StatefulWidget {
  Weight weight;
  double weightDifference;
  WeightListItem( {this.weight,this.weightDifference});
  @override
  State<StatefulWidget> createState() => WeightListItemState();
}
class WeightListItemState extends State<WeightListItem> {
  bool showEditLayout=false;

  void toggleeditlayoutvisiblaity()
  {
    setState(() {
      showEditLayout=!showEditLayout;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(color:Colors.grey[900],borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: new Padding(
      padding: new EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 20),
      child:new Column(
    children: [
      new InkWell(
         onTap: (){showEditWeightDialog(context,widget.weight);},
        child: new Column(
          children: [
              new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Expanded(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                  children: [
                    new Text(
                      new DateFormat.MMMEd().format(widget.weight.dateTime),
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.left,
                      style: TextStyle(color:Colors.white),
                    ),
                    new Row(children: [
                       if(widget.weightDifference>0)
                        Icon(widget.weightDifference>0?Icons.arrow_upward:Icons.arrow_downward,color:widget.weightDifference>0?Colors.red:Colors.green,size: 15,),
                          new Text(
                      _differenceText(widget.weightDifference),
                      textAlign: TextAlign.right,
                      style: widget.weightDifference>0?TextStyle(color: Colors.red,fontSize: 15):TextStyle(color: Colors.green,fontSize: 15) ,
                    ),
                    ]
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                ),
              ],
            ),
          ),
          new Row(children: [
            new Text(
            widget.weight.weight.toString(),
            style: TextStyle(fontSize: 30,color: Colors.white),
            textAlign: TextAlign.center,
          ),
            new Container(child:
               new Text(
              "kg",
              style: TextStyle(fontSize: 15,color: Colors.white),
            ),
            margin: EdgeInsets.only(top: 8),)

          ],)

        ],
      ),

        ])

      ),
    ],
    )


    ) ,
    );



  }

  String _differenceText(double weightDifference) {
      {
        if (weightDifference > 0) {
          return "+" + weightDifference.toStringAsFixed(1)+" kg";
        } else if (weightDifference < 0) {
          return weightDifference.toStringAsFixed(1)+" kg";
        } else {
          return "0 kg";
        }
      }
  }
  Future showEditWeightDialog(BuildContext context,Weight previosweight) async {
    Weight weight = await Navigator.of(context).push(
        new MaterialPageRoute<Weight>(
            builder: (BuildContext context) {
              return new AddEntryDialog(
                  previousorlastweight: previosweight, iseditoperation: true);
            },
            fullscreenDialog: true
        ));
    if (weight != null) {
      if (weight.weight == null && weight.dateTime == null) {
        Provider.of<WeightModel>(context).delete(previosweight);
      }
      else {
        Provider.of<WeightModel>(context).edit(previosweight,weight.weight);
      }
    }
  }

}