class PriceProduct {
  String? id;
  PriceType? priceType;
  String? minimumOrder;
  String? price;
  String? createdAt;
  String? updatedAt;

  PriceProduct(
      {this.id,
        this.priceType,
        this.minimumOrder,
        this.price,
        this.createdAt,
        this.updatedAt});

  PriceProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    priceType = json['price_type'] != null
        ? PriceType.fromJson(json['price_type'])
        : null;
    minimumOrder = json['minimum_order'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class PriceType {
  String? id;
  String? name;

  PriceType({this.id, this.name});

  PriceType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
