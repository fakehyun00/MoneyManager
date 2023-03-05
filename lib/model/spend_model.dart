class SpendModel {
  String id;
  String contentname;
  String desc;
  DateTime? date;
  int cost;
  bool? status;
  String? url;
  SpendModel(
      {this.id = '',
      this.cost = 0,
      this.date,
      this.status,
      this.url,
      this.desc = '',
      this.contentname = ''});
  factory SpendModel.fromMap(map) {
    return SpendModel(
        id: map.id,
        date: map['date'],
        desc: map['desc'],
        cost: map['cost'],
        url: map['url'],
        status: map['status'],
        contentname: map['contentname']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contentname': contentname,
      'desc': desc,
      'date': date,
      'cost': cost,
      'status': status,
      'url': url
    };
  }
}
