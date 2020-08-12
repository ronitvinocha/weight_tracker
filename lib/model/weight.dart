import 'dart:ffi';

class Weight {
  double weight;
  DateTime dateTime;
  String userId;
  Weight( {this.weight,this.dateTime});
  toJson() {
    return {
      "userId": userId,
      "weight": weight,
      "datetime": dateTime.toString(),
    };
  }
}