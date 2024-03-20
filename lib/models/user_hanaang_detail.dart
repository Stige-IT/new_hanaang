class UserHanaangDetail {
  String? id;
  String? image;
  String? name;
  String? email;
  String? phoneNumber;
  String? userRole;
  int? totalWarung;
  int? totalAgen;
  int? totalOrder;
  int? totalRetur;
  List<TotalHutang>? totalHutang;
  Address? address;

  UserHanaangDetail(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.phoneNumber,
      this.userRole,
      this.totalWarung,
      this.totalAgen,
      this.totalOrder,
      this.totalRetur,
      this.totalHutang,
      this.address});

  UserHanaangDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    userRole = json['user_role'];
    totalWarung = json['total_warung'];
    totalAgen = json['total_agen'];
    totalOrder = json['total_order'];
    totalRetur = json['total_retur'];
    if (json['total_hutang'] != null) {
      totalHutang = <TotalHutang>[];
      json['total_hutang'].forEach((v) {
        totalHutang!.add(TotalHutang.fromJson(v));
      });
    }
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }
}

class TotalHutang {
  String? statusId;
  String? statusName;

  TotalHutang({this.statusId, this.statusName});

  TotalHutang.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    statusName = json['status_name'];
  }
}

class Address {
  String? province;
  String? regency;
  String? district;
  String? village;
  String? detail;

  Address(
      {this.province, this.regency, this.district, this.village, this.detail});

  Address.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    regency = json['regency'];
    district = json['district'];
    village = json['village'];
    detail = json['detail'];
  }
}
