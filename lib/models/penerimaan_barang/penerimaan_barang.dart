class PenerimaanBarang {
  String? id;
  String? noPenerimaanBarang;
  String? totalPrice;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  PenerimaanBarang(
      {this.id,
        this.noPenerimaanBarang,
        this.totalPrice,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  PenerimaanBarang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noPenerimaanBarang = json['no_penerimaan_barang'];
    totalPrice = json['total_price'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
