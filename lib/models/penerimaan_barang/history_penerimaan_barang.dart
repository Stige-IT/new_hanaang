class HistoryPenerimaanBarang {
  String? id;
  String? penerimaanBarangId;
  String? rawMaterialId;
  String? price;
  String? quantity;
  String? createdAt;
  String? updatedAt;

  HistoryPenerimaanBarang(
      {this.id,
      this.penerimaanBarangId,
      this.rawMaterialId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt});

  HistoryPenerimaanBarang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    penerimaanBarangId = json['penerimaan_barang_id'];
    rawMaterialId = json['raw_material_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
