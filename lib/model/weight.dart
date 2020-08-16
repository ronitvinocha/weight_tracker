class Weight {
  double weight;
  DateTime dateTime;
  String userId;
  Weight( {this.weight,this.dateTime});
  toJson() {
    return {
      "weight": weight,
      "time": dateTime.toString(),
    };
  }
}