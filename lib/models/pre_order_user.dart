import 'package:admin_hanaang/models/user.dart';

class PreOrderUser {
  String? id;
  String? createdAt;
  String? poNumber;
  int? quantity;
  int? price;
  int? totalPrice;
  User? user;

  PreOrderUser(
      {this.id,
      this.createdAt,
      this.poNumber,
      this.quantity,
      this.price,
      this.totalPrice,
      this.user});

  PreOrderUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    poNumber = json['po_number'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['po_number'] = poNumber;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
