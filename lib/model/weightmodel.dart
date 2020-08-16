import 'package:flutter/cupertino.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:firebase_database/firebase_database.dart';

class WeightModel extends ChangeNotifier
{
  String userid;
  var dbref;
  WeightModel(String userid){
    print(userid);
    this.userid=userid;
    dbref=FirebaseDatabase.instance.reference().child(userid);
    getallweightfromdatabase(userid);
  }
  /// Internal, private state of the cart.
  final List<Weight> _items = [];

  /// An unmodifiable view of the items in the cart.
  List<Weight> get items => _items;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  //query and add
  void add(Weight weight) {
     dbref.push().set({
      "weight":weight.weight,
       "time":weight.dateTime.toString()
     }).catchError((onError) {
         debugPrint(onError.toString());
     });
     getallweightfromdatabase(userid);
  }
  //querty and edit
  void edit(Weight weight,double newweight)
  {
    Query weightquery = dbref.orderByChild("time").equalTo(weight.dateTime.toString());
    weightquery.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> weightmap = dataSnapshot.value;
           weightmap.forEach((key, value) {
              if(value['weight']==weight.weight)
                {
                    weight.weight=newweight;
                    dbref.child(key.toString()).set(weight.toJson());
                    getallweightfromdatabase(userid);
                }
          });
    });
  }
  //query and delete
  void delete(Weight weight)
  {
    Query weightquery = dbref.orderByChild("time").equalTo(weight.dateTime.toString());
    weightquery.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> weightmap = dataSnapshot.value;
           weightmap.forEach((key, value) {
            if(value['weight']==weight.weight)
                {
                    dbref.child(key.toString()).remove();
                    getallweightfromdatabase(userid);
                }
          });
    });
 }
 //sorting by order of datetime
  void sortusingdatetime()
{
  _items.sort((a,b)=>b.dateTime.compareTo(a.dateTime));
  for (Weight weight in _items)
    {
      print("🍎${weight.weight}");
    }
}
//get all weigh inputs from firebase realtime database
  void getallweightfromdatabase(String userid){
      if(_items.length!=0)
        {
          _items.clear();
        }
       dbref.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> weights = snapshot.value;
         if(weights!=null)
            {
              weights.forEach((key,value) {
                _items.add( Weight(weight:  double.parse(value["weight"].toString()), dateTime:DateTime.parse(value["time"]) ));
              });
              sortusingdatetime();
              notifyListeners();
            }
         else
           {
             notifyListeners();
           }
       });

  }
}