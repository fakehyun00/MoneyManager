class DayModel {
  String? id;
  int toTal;
  DayModel({this.toTal = 0, this.id});
  factory DayModel.fromMap(map) {
    return DayModel(id: map.id, toTal: map['toTal']);
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'toTal': toTal};
  }
}
