class Suplayer {
  String? id;
  String? image;
  String? name;
  String? phoneNumber;
  Address? address;
  List<RawMaterial>? rawMaterial;

  Suplayer(
      {this.id,
      this.image,
      this.name,
      this.phoneNumber,
      this.address,
      this.rawMaterial});

  Suplayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    if (json['raw_material'] != null) {
      rawMaterial = <RawMaterial>[];
      json['raw_material'].forEach((v) {
        rawMaterial!.add(RawMaterial.fromJson(v));
      });
    }
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

class RawMaterial {
  String? id;
  String? suplayerId;
  String? name;
  String? unitId;
  String? stock;
  String? remainingStock;
  String? unitPrice;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  RawMaterial(
      {this.id,
      this.suplayerId,
      this.name,
      this.unitId,
      this.stock,
      this.remainingStock,
      this.unitPrice,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  RawMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    suplayerId = json['suplayer_id'];
    name = json['name'];
    unitId = json['unit_id'];
    stock = json['stock'];
    remainingStock = json['remaining_stock'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
