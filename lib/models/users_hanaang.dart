class UsersHanaang {
  String? id;
  String? image;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phoneNumber;
  String? roleId;
  String? suspend;
  String? addressId;
  String? createdAt;
  String? updatedAt;

  UsersHanaang(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phoneNumber,
      this.roleId,
      this.suspend,
      this.addressId,
      this.createdAt,
      this.updatedAt});

  UsersHanaang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    suspend = json['suspend'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
