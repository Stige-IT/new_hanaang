class HistoryOutcome {
  String? id;
  Category? category;
  Type? type;
  PenerimaanBarang? penerimaanBarang;

  HistoryOutcome({this.id, this.category, this.type, this.penerimaanBarang});

  HistoryOutcome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    penerimaanBarang = json['penerimaan_barang'] != null
        ? PenerimaanBarang.fromJson(json['penerimaan_barang'])
        : null;
  }
}

class Category {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Type {
  String? id;
  String? financeCategoryId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Type(
      {this.id,
      this.financeCategoryId,
      this.name,
      this.createdAt,
      this.updatedAt});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    financeCategoryId = json['finance_category_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class PenerimaanBarang {
  String? id;
  String? noPenerimaanBarang;
  String? totalPrice;
  String? createdBy;
  List<Item>? item;

  PenerimaanBarang(
      {this.id,
      this.noPenerimaanBarang,
      this.totalPrice,
      this.createdBy,
      this.item});

  PenerimaanBarang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noPenerimaanBarang = json['no_penerimaan_barang'];
    totalPrice = json['total_price'];
    createdBy = json['created_by'];
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
  }
}

class Item {
  String? id;
  RawMaterial? rawMaterial;
  String? quantity;
  String? price;

  Item({this.id, this.rawMaterial, this.quantity, this.price});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rawMaterial = json['raw_material'] != null
        ? RawMaterial.fromJson(json['raw_material'])
        : null;
    quantity = json['quantity'];
    price = json['price'];
  }
}

class RawMaterial {
  String? id;
  String? name;
  String? unit;

  RawMaterial({this.id, this.name, this.unit});

  RawMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unit = json['unit'];
  }
}
