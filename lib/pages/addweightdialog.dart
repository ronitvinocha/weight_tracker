import 'dart:ffi';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weight_tracker/model/weight.dart';

class AddEntryDialog extends StatefulWidget {
  double initialweight;
  AddEntryDialog({this.initialweight});
  @override
  AddEntryDialogState createState() => new AddEntryDialogState(weight: initialweight);
}

class AddEntryDialogState extends State<AddEntryDialog> {
  DateTime _dateTime = new DateTime.now();
  double weight;
  AddEntryDialogState({this.weight});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Column(
        children: [
          new ListTile(
            leading: new Icon(Icons.today, color: Colors.grey[500]),
            title: new DateTimeItem(_dateTime,(dateTime) => setState(() => _dateTime = dateTime))
          ),
          new ListTile(
            leading: new Image.asset(
              "assets/scale-bathroom.png",
              color: Colors.grey[500],
              height: 24.0,
              width: 24.0,
            ),
            title: new Text(weight==0?60.toString()+" kg":weight.toString()+" kg",),
            onTap: () => _showWeightPicker(context),
          ),
    ]));
  }

  @override
  void initState() {
    super.initState();
  }
  _showWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      child: new NumberPickerDialog.decimal(
        minValue: 0,
        maxValue: 150,
        initialDoubleValue: weight==0?60:weight,
        title: new Text("Enter your weight"),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => weight = value);
      }
    });
  }
  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: const Text('New entry'),
      actions: [
        new FlatButton(
            onPressed: () {
              Navigator
                  .of(context)
                  .pop(new Weight(
                  weight: weight,
                  dateTime: _dateTime));
            },
            child: new Text('SAVE',
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white))),
      ],
    );
  }
}



class DateTimeItem extends StatelessWidget {
    DateTime date;
   TimeOfDay time;
   ValueChanged<DateTime> onChanged;
  DateTimeItem(DateTime date, ValueChanged<DateTime> onchanged){
    this.date=date;
    this.onChanged=onchanged;
    this.time=TimeOfDay.fromDateTime(date);
  }

//        date = dateTime == null
//            ? new DateTime.now()
//            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
//        time = dateTime == null
//            ? new DateTime.now()
//            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),



  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new InkWell(
            onTap: (() => _showDatePicker(context)),
            child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Text(new DateFormat('EEEE, MMMM d').format(date))),
          ),
        ),
        new InkWell(
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Text(time.format(context))),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
