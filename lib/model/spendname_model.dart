class SpendItem {
  String? id;
  String? content;
  bool? status;
  String? url;
  SpendItem({this.url, this.content, this.id, this.status});

  factory SpendItem.fromMap(map) {
    return SpendItem(
        id: map.id,
        content: map["content"],
        status: map["status"],
        url: map['url']);
  }
  Map<String, dynamic> toMap() {
    return {'content': content, 'status': status, 'id': id, 'url': url};
  }
}
