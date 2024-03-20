class BankHistory {
  String? id;
  String? category;
  String? type;
  String? nominal;
  String? createdAt;

  BankHistory(
      {this.id, this.category, this.type, this.nominal, this.createdAt});

  BankHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    type = json['type'];
    nominal = json['nominal'];
    createdAt = json['created_at'];
  }
}
