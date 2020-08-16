import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//a widget for a weight picker stooping at int value but also select required weight on tap.
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
    selectedweight=(((firstVisibleItemIndex+factor)/10)).roundToDouble();
    widget.setWeight(selectedweight);
  });
}
void firstscroll()
{
  if(!firsttimescrolling)
    {
      double scrollRange = scrollController.position.maxScrollExtent -
                        scrollController.position.minScrollExtent;
      double offset=(selectedweight)*(scrollRange/150);
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
            style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.bold),
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
                if (scrollNotification is ScrollEndNotification) {
                  if(firsttimescrolling)
                    {
                       WidgetsBinding.instance.addPostFrameCallback((_) => getmiddleindex());
                    }
                }
              },
             child:new ListView.builder(
                 shrinkWrap: true,
                 physics:  AlwaysScrollableScrollPhysics (),
                 itemCount: 150*10,
                 itemExtent: 17,
                 scrollDirection: Axis.horizontal,
                 controller: scrollController,
                 itemBuilder: (context,index){
                   if(index/10==selectedweight)
                     {
                       return  Container(
                        child:new SelectedLine(),
                        height: 10,
                      );
                     }
                  else if(index%10!=0)
                    {
                      return  InkWell(
                        child: Container(
                        child:new DecimalLine(),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: intLine((index/10).toInt()),
                            margin: EdgeInsets.only(bottom: 3,left: 0,right: 1),
                            height: 30,
                            width: 10,
                          ),
                          Text((index/10).toInt().toString(),style: TextStyle(color: Colors.white70,fontSize: 10),textAlign: TextAlign.center,)
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
class SelectedLine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      child:VerticalDivider(color: Theme.of(context).accentColor,
          thickness: 5, width: 5,
          indent: 0,
          endIndent: 50),
      padding: EdgeInsets.only(left: 5,right: 5),
    );
  }

}
class DecimalLine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      child:VerticalDivider(color: Colors.white70,
          thickness: 2, width: 2,
          indent: 10,
          endIndent: 70),
      padding: EdgeInsets.only(left: 5,right: 5),
    );
  }

}
class IntLine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Padding(
     child:VerticalDivider(color: Colors.white70,
          thickness: 2, width: 2,
          indent: 0,
          endIndent: 0),
     padding: EdgeInsets.only(left:5,right: 5),
   );
  }
  }

