class HistoryIncome {
  String? id;
  Category? category;
  Type? type;
  Order? order;
  OrderPayment? orderPayment;

  HistoryIncome(
      {this.id, this.category, this.type, this.order, this.orderPayment});

  HistoryIncome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    orderPayment = json['order_payment'] != null
        ? OrderPayment.fromJson(json['order_payment'])
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

class Order {
  String? id;
  String? createdAt;
  String? orderNumber;
  String? totalPrice;
  String? totalOrder;
  String? paymentStatus;
  String? orderTakingStatus;

  Order(
      {this.id,
      this.createdAt,
      this.orderNumber,
      this.totalPrice,
      this.totalOrder,
      this.paymentStatus,
      this.orderTakingStatus});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    orderNumber = json['order_number'];
    totalPrice = json['total_price'];
    totalOrder = json['total_order'];
    paymentStatus = json['payment_status'];
    orderTakingStatus = json['order_taking_status'];
  }
}

class OrderPayment {
  String? id;
  String? paymentMethodId;
  String? proofOfPayment;
  String? nominal;
  String? createdAt;
  CreatedBy? createdBy;

  OrderPayment(
      {this.id,
      this.paymentMethodId,
      this.proofOfPayment,
      this.nominal,
      this.createdAt,
      this.createdBy});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethodId = json['payment_method_id'];
    proofOfPayment = json['proof_of_payment'];
    nominal = json['nominal'];
    createdAt = json['created_at'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
  }
}

class CreatedBy {
  String? name;
  String? email;
  String? phoneNumber;

  CreatedBy({this.name, this.email, this.phoneNumber});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }
}
