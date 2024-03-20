class UnitModel {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  UnitModel({this.id, this.name, this.createdAt, this.updatedAt});

  UnitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
