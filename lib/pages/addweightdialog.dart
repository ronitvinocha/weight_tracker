import 'dart:ffi';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:weight_tracker/uielements/datepicker.dart';
import 'package:weight_tracker/uielements/weightPicker.dart';

class AddEntryDialog extends StatefulWidget {
  Weight previousorlastweight;
  bool iseditoperation;
  AddEntryDialog({this.previousorlastweight,this.iseditoperation});
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  DateTime _selectedDate=DateTime.now();
  double _selectedweight=60;
  void  updateselectedDateTime(DateTime selectedDatetime)
  {
    print(selectedDatetime);
   setState(() {
     this._selectedDate=selectedDatetime;
   });
  }
  void  updateselectedweight(double selectedweight)
  {
    print(selectedweight);
   setState(() {
     this._selectedweight=selectedweight;
   });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: _createAppBar(context),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child:  new Column(
        children: [
          Visibility(
            child:  new DatePicker(setparentselectedDate: updateselectedDateTime),
            visible: !widget.iseditoperation,
          ),
          widget.previousorlastweight==null?
              new WeightPicker(setWeight: updateselectedweight,previousweight: 60)
              :
              new WeightPicker(setWeight: updateselectedweight,previousweight: widget.previousorlastweight.weight)
        ]),
      ),
     floatingActionButton: Container(
                decoration: new BoxDecoration(color: Theme.of(context).accentColor,borderRadius: BorderRadius.all(Radius.circular(50)),),
                width: 250.0,
                height: 50.0,
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  elevation: 0.0,
                  child: Text("Save",style: TextStyle(fontFamily: 'roboto',fontSize: 20,fontWeight: FontWeight.bold),),
                onPressed: (){
                    Navigator
                  .of(context)
                  .pop(new Weight(weight: _selectedweight,dateTime: _selectedDate));
                  },
                )
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
     );
  }

  @override
  void initState() {
    super.initState();
  }
  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.iseditoperation?const Text('Edit weight'):const Text('Add weight'),
      backgroundColor: Colors.black,
      actions: [
        Visibility(
          visible: widget.iseditoperation,
          child:new FlatButton(
            onPressed: () {
              Navigator
                  .of(context)
                  .pop(new Weight(weight: null,dateTime: null));
            },
            child: Icon(Icons.delete,color: Colors.white))

        )

      ],
    );
  }
}
