import 'package:flutter/cupertino.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:firebase_database/firebase_database.dart';

class WeightModel extends ChangeNotifier
{
  String userid;
  var dbref;
  WeightModel(String userid){
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
    _items.add(weight);
     dbref.push().set({
      "weight":weight.weight,
       "time":weight.dateTime.toString()
     }).catchError((onError) {
         debugPrint(onError.toString());
     });
     sortusingdatetime();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
  void sortusingdatetime()
{
  _items.sort((a,b)=>b.dateTime.compareTo(a.dateTime));
}
  void getallweightfromdatabase(String userid){
       dbref.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> weights = snapshot.value;
         if(weights!=null)
            {
              weights.forEach((key,value) {
                print(value);
                _items.add( Weight(weight:  double.parse(value["weight"].toString()), dateTime:DateTime.parse(value["time"]) ));
              });
              sortusingdatetime();
              notifyListeners();
            }
       });
  }
}