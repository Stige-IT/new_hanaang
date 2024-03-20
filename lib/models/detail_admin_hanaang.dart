class DetailAdminHanaang {
  String? id;
  String? image;
  String? name;
  String? email;
  String? phoneNummber;
  String? suspend;
  String? userRole;
  Address? address;

  DetailAdminHanaang(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.phoneNummber,
      this.suspend,
      this.userRole,
      this.address});

  DetailAdminHanaang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    phoneNummber = json['phone_nummber'];
    suspend = json['suspend'];
    userRole = json['user_role'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }
}

class Address {
  String? id;
  Province? province;
  Province? regency;
  Province? district;
  Province? village;
  String? detail;

  Address(
      {this.id,
      this.province,
      this.regency,
      this.district,
      this.village,
      this.detail});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    regency =
        json['regency'] != null ? Province.fromJson(json['regency']) : null;
    district =
        json['district'] != null ? Province.fromJson(json['district']) : null;
    village =
        json['village'] != null ? Province.fromJson(json['village']) : null;
    detail = json['detail'];
  }
}

class Province {
  int? id;
  String? name;

  Province({this.id, this.name});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
