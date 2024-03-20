class User {
  String? id;
  String? image;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phoneNumber;
  String? roleName;
  String? suspend;
  String? addressId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phoneNumber,
      this.roleName,
      this.suspend,
      this.addressId,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneNumber = json['phone_number'];
    roleName = json['role_id'];
    suspend = json['suspend'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_number'] = phoneNumber;
    data['role_name'] = roleName;
    data['suspend'] = suspend;
    data['address_id'] = addressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
