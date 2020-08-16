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
      decoration: BoxDecoration(color:Theme.of(context).secondaryHeaderColor,borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
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
                    difference(widget.weightDifference),
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
  void showEditWeightDialog(BuildContext context,Weight previosweight) async {
    Weight weight = await Navigator.of(context).push(
        new MaterialPageRoute<Weight>(
            builder: (BuildContext context) {
              return new AddEntryDialog(
                  previousorlastweight: previosweight, iseditoperation: true);
            },
            fullscreenDialog: false
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
  Widget difference(double weightdufference)
  {
     Color green=Colors.green;
     Color red=Colors.red;
     Color yellow=Colors.yellow;
     Icon up=Icon(Icons.arrow_upward,color: red,);
     Icon down=Icon(Icons.arrow_downward,color: green,);
     Icon nochange=Icon(Icons.remove,color: yellow,);
     if(weightdufference==0)
       {
          return new Row(children: [
           nochange,
          new Text(
            weightdufference.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: TextStyle(color: yellow,fontSize: 15) ,
          ),
        ]
        );
       }
    else if(weightdufference>0)
      {
        return new Row(children: [
           up,
          new Text(
            weightdufference.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: TextStyle(color: red,fontSize: 15) ,
          ),
        ]
        );
      }
    else
      {
        return new Row(children: [
           down,
          new Text(
            weightdufference.abs().toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: TextStyle(color: green,fontSize: 15) ,
          ),
        ]
        );
      }
  }
}