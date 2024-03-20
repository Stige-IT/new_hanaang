class Stock {
  String? id;
  String? stock;

  Stock({this.stock});

  Stock.fromJson(Map<String, dynamic> json) {
    stock = json['data'];
  }
}
