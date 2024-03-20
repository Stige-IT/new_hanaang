class Shopping {
  String? id;
  List<ShoppingItem>? shoppingItem;
  String? totalPrice;
  CreatedBy? createdBy;
  String? createdAt;

  Shopping(
      {this.id,
      this.shoppingItem,
      this.totalPrice,
      this.createdBy,
      this.createdAt});

  Shopping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['shopping_item'] != null) {
      shoppingItem = <ShoppingItem>[];
      json['shopping_item'].forEach((v) {
        shoppingItem!.add(ShoppingItem.fromJson(v));
      });
    }
    totalPrice = json['total_price'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
  }
}

class ShoppingItem {
  String? id;
  String? shoppingId;
  String? name;
  String? quantity;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  ShoppingItem(
      {this.id,
      this.shoppingId,
      this.name,
      this.quantity,
      this.price,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  ShoppingItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shoppingId = json['shopping_id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class CreatedBy {
  String? id;
  String? name;
  String? email;

  CreatedBy({this.id, this.name, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }
}
