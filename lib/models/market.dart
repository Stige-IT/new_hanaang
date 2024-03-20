class Market {
  String? id;
  String? userId;
  String? name;
  String? image;
  String? addressId;
  String? createdAt;
  String? updatedAt;

  Market(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.addressId,
      this.createdAt,
      this.updatedAt});

  Market.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
