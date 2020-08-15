import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WeightPicker extends StatefulWidget{
  final ValueChanged<double> setWeight;
  final double previousweight ;
  WeightPicker({this.setWeight,this.previousweight});
  @override
  State<StatefulWidget> createState() =>WeightPickerState();
}

class WeightPickerState extends State<WeightPicker>{
  double selectedweight;
  ScrollController scrollController;
  bool firsttimescrolling=false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    selectedweight=widget.previousweight;
  }
  void getmiddleindex()
{
  int itemCount = 150*10;
  double scrollOffset = scrollController.position.pixels;
  double viewportHeight = scrollController.position.viewportDimension;
  double scrollRange = scrollController.position.maxScrollExtent -
                        scrollController.position.minScrollExtent;
  int firstVisibleItemIndex = (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
  int lastvisibleitemindex=((scrollOffset+viewportHeight)/(scrollRange + viewportHeight) * itemCount).floor();
  double factor=(lastvisibleitemindex-firstVisibleItemIndex)/2;
  setState(() {
    selectedweight=(((firstVisibleItemIndex+factor)/10)+0.2).roundToDouble();
    widget.setWeight(selectedweight);
  });
}
void firstscroll()
{
  if(!firsttimescrolling)
    {
      print(selectedweight);
      double scrollRange = scrollController.position.maxScrollExtent -
                        scrollController.position.minScrollExtent;
      double offset=(selectedweight+3)*(scrollRange/150);
      scrollController.jumpTo(offset);
      firsttimescrolling=true;
    }
}
  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) => firstscroll());
   return new Container(
     margin: EdgeInsets.only(top: 15),
     child: new Column(
     children: [
         new Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            new Text(
            selectedweight.toString(),
            style: TextStyle(fontSize: 60,color: Colors.white),
            textAlign: TextAlign.center,
          ),
            new Container(child:
               new Text(
              "kg",
              style: TextStyle(fontSize: 25,color: Colors.white),
            ),
            margin: EdgeInsets.only(top: 20),)

          ],
         ),
       new Container(
            height: 90,
           margin: EdgeInsets.symmetric(vertical: 15.0),
           child: NotificationListener<ScrollNotification>(
             onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  
                } else if (scrollNotification is ScrollUpdateNotification) {


                } else if (scrollNotification is ScrollEndNotification) {
                  if(firsttimescrolling)
                    {
                       WidgetsBinding.instance.addPostFrameCallback((_) => getmiddleindex());
                    }
                }
              },
             child:new ListView.builder(
                 physics: const AlwaysScrollableScrollPhysics (),
                 itemCount: 150*10,
                 scrollDirection: Axis.horizontal,
                 controller: scrollController,
                 itemBuilder: (context,index){
                   if(index/10==selectedweight)
                     {
                       return  Container(
                        child:selectedLine(),
                        height: 10,
                      );
                     }
                  else if(index%10!=0)
                    {
                      return  InkWell(
                        child: Container(
                        child:decimalLine(),
                        height: 40,
                        width: 10,
                        ),
                        onTap: (){
                          widget.setWeight(index/10);
                          setState(() {
                          selectedweight=(index/10);
                        });} ,
                      );
                    }
                  else
                    {
                      return InkWell(
                        child: new Column(
                        children: [
                          Container(
                            child: intLine((index/10).toInt()),
                            height: 30,
                            width: 10,
                          ),
                          Text((index/10).toInt().toString(),style: TextStyle(color: Colors.white70),)
                        ],
                          mainAxisSize: MainAxisSize.max,
                      ),
                        onTap: (){
                           widget.setWeight(index/10);
                          setState(() {
                          selectedweight=(index/10);
                        });},
                      );

                    }
          },
             )
           ) ,
           )

     ],
     )
   );


  }
  Widget selectedLine()
  {
    return Padding(
      child:VerticalDivider(color: Theme.of(context).accentColor,
          thickness: 5, width: 5,
          indent: 0,
          endIndent: 50),
      padding: EdgeInsets.only(left: 5,right: 5),
    );
  }

  Widget decimalLine()
  {
    return Padding(
      child:VerticalDivider(color: Colors.white70,
          thickness: 2, width: 2,
          indent: 10,
          endIndent: 70),
      padding: EdgeInsets.only(left: 5,right: 5),
    );
  }
  Widget intLine(int value)
  {
   return Padding(
     child:VerticalDivider(color: Colors.white70,
          thickness: 2, width: 2,
          indent: 0,
          endIndent: 0),
     padding: EdgeInsets.only(left:5,right: 5),
   );
  }

}