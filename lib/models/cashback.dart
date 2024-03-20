class Cashback {
  String? id;
  CashbackType? cashbackType;
  String? minimumOrder;
  String? numberOfCashback;
  String? createdAt;
  String? updatedAt;

  Cashback(
      {this.id,
        this.cashbackType,
        this.minimumOrder,
        this.numberOfCashback,
        this.createdAt,
        this.updatedAt});

  Cashback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cashbackType = json['cashback_type'] != null
        ? CashbackType.fromJson(json['cashback_type'])
        : null;
    minimumOrder = json['minimum_order'];
    numberOfCashback = json['number_of_cashback'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class CashbackType {
  String? id;
  String? name;

  CashbackType({this.id, this.name});

  CashbackType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
