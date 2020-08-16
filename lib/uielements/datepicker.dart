import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
class DatePicker extends StatefulWidget
{
  final ValueChanged<DateTime> setparentselectedDate;
  DateTime fixedDate;
  DatePicker({this.setparentselectedDate,this.fixedDate});
  @override
  State<StatefulWidget> createState() =>DatePickerState();

}
class DatePickerState extends State<DatePicker>{
  DateTime _selectedDate;
  DateTime _firstDate;
  DateTime _lastDate;
  Color selectedDateStyleColor;
  Color selectedSingleDateDecorationColor;
  dp.DatePickerStyles styles;
  @override
  void initState() {
    super.initState();
    _firstDate = widget.fixedDate;
    _selectedDate = widget.fixedDate;
    _lastDate = widget.fixedDate;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // defaults for styles
    selectedDateStyleColor = Colors.white;
    selectedSingleDateDecorationColor = Theme.of(context).accentColor;
    styles = dp.DatePickerRangeStyles(
        nextIcon: Icon(Icons.arrow_forward_ios,color: Colors.white,),
        prevIcon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        disabledDateStyle: TextStyle(color: Colors.grey),
        currentDateStyle: Theme.of(context)
            .accentTextTheme
            .bodyText1
            .copyWith(color: selectedDateStyleColor),
        defaultDateTextStyle: Theme.of(context)
            .accentTextTheme
            .bodyText1
            .copyWith(color: selectedDateStyleColor),
        selectedDateStyle: TextStyle(color: Colors.black),
        displayedPeriodTitle: TextStyle(color: Colors.white),
        selectedSingleDateDecoration: BoxDecoration(
            color: Theme.of(context).accentColor, shape: BoxShape.circle));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
          margin: EdgeInsets.only(left: 16,right: 16),
          padding: EdgeInsets.only(top: 20,bottom: 20),
          height: 380,
            child:dp.DayPicker(
            onChanged: _onSelectedDateChanged,
            selectedDate: _selectedDate,
            firstDate: _firstDate,
            lastDate: _lastDate,
            datePickerStyles: styles,
            datePickerLayoutSettings: dp.DatePickerLayoutSettings(maxDayPickerRowCount: 2),
          ),
            decoration: BoxDecoration(color: Colors.grey[900],borderRadius: BorderRadius.circular(15)),
          );
  }
void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    widget.setparentselectedDate(_selectedDate);
  }
}