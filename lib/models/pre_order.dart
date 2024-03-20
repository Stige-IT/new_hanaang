class PreOrder {
  String? id;
  String? start;
  String? end;
  int? stockPo;
  int? sisaStockPo;
  String? createdAt;
  String? updatedAt;

  PreOrder(
      {this.id,
      this.start,
      this.end,
      this.stockPo,
      this.sisaStockPo,
      this.createdAt,
      this.updatedAt});

  PreOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    end = json['end'];
    stockPo = json['stock_po'];
    sisaStockPo = json['sisa_stock_po'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start'] = start;
    data['end'] = end;
    data['stock_po'] = stockPo;
    data['sisa_stock_po'] = sisaStockPo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
