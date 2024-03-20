class DetailPenerimaanBarang {
  String? id;
  String? noPenerimaanBarang;
  String? totalPrice;
  String? createdBy;
  List<Item>? item;

  DetailPenerimaanBarang(
      {this.id,
        this.noPenerimaanBarang,
        this.totalPrice,
        this.createdBy,
        this.item});

  DetailPenerimaanBarang.fromJson(Map<String, dynamic> json) {
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
