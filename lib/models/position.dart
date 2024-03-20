class Position {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Position({this.id, this.name, this.createdAt, this.updatedAt});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
