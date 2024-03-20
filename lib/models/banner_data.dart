class BannerData {
  String? id;
  String? image;
  String? detail;
  String? createdAt;
  String? updatedAt;

  BannerData(
      {this.id, this.image, this.detail, this.createdAt, this.updatedAt});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    detail = json['detail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
