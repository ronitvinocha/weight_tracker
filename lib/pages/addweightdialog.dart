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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _createAppBar(context),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child:  new Column(
        children: [
          widget.iseditoperation?new DatePicker(setparentselectedDate: updateselectedDateTime,fixedDate: widget.previousorlastweight.dateTime,):
              new DatePicker(setparentselectedDate: updateselectedDateTime,fixedDate: DateTime.now()),
          widget.previousorlastweight==null?
              new WeightPicker(setWeight: updateselectedweight,previousweight: 60)
              :
              new WeightPicker(setWeight: updateselectedweight,previousweight: widget.previousorlastweight.weight)
        ]),
      ),
     floatingActionButton: SizedBox(height: 40,width: 200,
                    child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                      color: Theme.of(context).accentColor,
                  child: Text("Save",style: TextStyle(fontFamily: 'roboto',fontSize: 20,fontWeight: FontWeight.bold),),
                onPressed: (){
                    Navigator
                  .of(context)
                  .pop(new Weight(weight: _selectedweight,dateTime: _selectedDate));
                  },
                )),
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
      backgroundColor: Theme.of(context).primaryColor,
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
