class UserAddress {
  String? id;
  Province? province;
  Province? regency;
  Province? district;
  Province? village;
  String? detail;

  UserAddress(
      {this.id,
        this.province,
        this.regency,
        this.district,
        this.village,
        this.detail});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province = json['province'] != null
        ? Province.fromJson(json['province'])
        : null;
    regency =
    json['regency'] != null ? Province.fromJson(json['regency']) : null;
    district = json['district'] != null
        ? Province.fromJson(json['district'])
        : null;
    village =
    json['village'] != null ? Province.fromJson(json['village']) : null;
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (province != null) {
      data['province'] = province!.toJson();
    }
    if (regency != null) {
      data['regency'] = regency!.toJson();
    }
    if (district != null) {
      data['district'] = district!.toJson();
    }
    if (village != null) {
      data['village'] = village!.toJson();
    }
    data['detail'] = detail;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
