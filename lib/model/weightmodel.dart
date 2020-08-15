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
  void add(Weight weight) {
     dbref.push().set({
      "weight":weight.weight,
       "time":weight.dateTime.toString()
     }).catchError((onError) {
         debugPrint(onError.toString());
     });
     getallweightfromdatabase(userid);
//     sortusingdatetime();
    // This call tells the widgets that are listening to this model to rebuild.
//    notifyListeners();
  }
  void edit(Weight weight,double newweight)
  {
    print(weight.dateTime.toString());
    Query weightquery = dbref.orderByChild("time").equalTo(weight.dateTime.toString());
    print(weightquery);
    weightquery.once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);
      Map<dynamic, dynamic> weightmap = dataSnapshot.value;
           weightmap.forEach((key, value) {
             print(value);
              if(value['weight']==weight.weight)
                {
                    print(key);
                    weight.weight=newweight;
                    dbref.child(key.toString()).set(weight.toJson());
                    getallweightfromdatabase(userid);
                }
          });
    });
//    weightquery.on
//    weightquery.addListenerForSingleValueEvent(new ValueEventListener() {
//        @Override
//        public void onDataChange(DataSnapshot dataSnapshot) {
//            for (DataSnapshot appleSnapshot: dataSnapshot.getChildren()) {
//                appleSnapshot.getRef().removeValue();
//            }
//        }
//
//        @Override
//        public void onCancelled(DatabaseError databaseError) {
//            Log.e(TAG, "onCancelled", databaseError.toException());
//        }
//    });
  }
  void delete(Weight weight)
  {
    Query weightquery = dbref.orderByChild("time").equalTo(weight.dateTime.toString());
    print(weightquery.toString());
    weightquery.once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);
      Map<dynamic, dynamic> weightmap = dataSnapshot.value;
           weightmap.forEach((key, value) {
             print(value);
              if(value['weight']==weight.weight)
                {
                    print(key);
                    dbref.child(key.toString()).remove();
                    getallweightfromdatabase(userid);
                }
          });
    });
//    weightquery.addListenerForSingleValueEvent(new ValueEventListener() {
//        @Override
//        public void onDataChange(DataSnapshot dataSnapshot) {
//            for (DataSnapshot appleSnapshot: dataSnapshot.getChildren()) {
//                appleSnapshot.getRef().removeValue();
//            }
//        }
//
//        @Override
//        public void onCancelled(DatabaseError databaseError) {
//            Log.e(TAG, "onCancelled", databaseError.toException());
//        }
//    });

  }
  void sortusingdatetime()
{
  _items.sort((a,b)=>b.dateTime.compareTo(a.dateTime));
  for (Weight weight in _items)
    {
      print("🍎${weight.weight}");
    }
}
  void getallweightfromdatabase(String userid){
      if(_items.length!=0)
        {
          _items.clear();
        }
       dbref.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> weights = snapshot.value;
        print("🙏🏻$weights");
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