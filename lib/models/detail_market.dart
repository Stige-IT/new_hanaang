class DetailMarket {
  String? id;
  String? name;
  String? image;
  Address? address;

  DetailMarket({this.id, this.name, this.image, this.address});

  DetailMarket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }
}

class Address {
  String? id;
  Province? province;
  Province? regency;
  Province? district;
  Province? vilage;
  String? detail;

  Address(
      {this.id,
      this.province,
      this.regency,
      this.district,
      this.vilage,
      this.detail});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    regency =
        json['regency'] != null ? Province.fromJson(json['regency']) : null;
    district =
        json['district'] != null ? Province.fromJson(json['district']) : null;
    vilage = json['vilage'] != null ? Province.fromJson(json['vilage']) : null;
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
