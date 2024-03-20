class MaterialModel {
  String? id;
  String? name;
  String? unit;
  String? stock;
  String? remainingStock;
  String? unitPrice;
  String? totalPrice;
  String? createdAt;

  MaterialModel(
      {this.id,
      this.name,
      this.unit,
      this.stock,
      this.remainingStock,
      this.unitPrice,
      this.totalPrice,
      this.createdAt});

  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unit = json['unit'];
    stock = json['stock'];
    remainingStock = json['remaining_stock'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw_material_id'] = id;
    // data['name'] = name;
    // data['unit'] = unit;
    // data['price'] = price;
    // data['total_price'] = totalPrice;
    data['quantity'] = stock;
    return data;
  }
}
