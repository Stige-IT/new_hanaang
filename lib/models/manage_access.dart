class ManageAccess {
  String? id;
  String? type;
  String? categoryAccess;
  String? create;
  String? read;
  String? update;
  String? delete;
  UpdatedBy? updatedBy;

  ManageAccess(
      {this.id,
      this.type,
      this.categoryAccess,
      this.create,
      this.read,
      this.update,
      this.delete,
      this.updatedBy});

  ManageAccess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    categoryAccess = json['category_access'];
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
    updatedBy = json['updatedBy'] != null
        ? UpdatedBy.fromJson(json['updatedBy'])
        : null;
  }
}

class UpdatedBy {
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

  UpdatedBy(
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

  UpdatedBy.fromJson(Map<String, dynamic> json) {
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
