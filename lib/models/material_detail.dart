import 'suplayer.dart';

class MaterialDetail {
  String? id;
  String? name;
  String? unit;
  String? stock;
  String? remainingStock;
  String? unitPrice;
  String? totalPrice;
  Suplayer? suplayer;

  MaterialDetail(
      {this.id,
      this.name,
      this.unit,
      this.stock,
      this.remainingStock,
      this.unitPrice,
      this.totalPrice,
      this.suplayer});

  MaterialDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unit = json['unit'];
    stock = json['stock'];
    remainingStock = json['remaining_stock'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    if (json['suplayer'] != null) {
      suplayer = Suplayer.fromJson(json['suplayer']);
    } else {
      suplayer = null;
    }
  }
}
