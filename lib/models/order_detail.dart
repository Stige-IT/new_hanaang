class OrderDetailData {
  String? id;
  String? createdAt;
  String? orderNumber;
  String? quantity;
  String? bonus;
  String? cashback;
  String? price;
  int? totalPrice;
  int? totalOrder;
  CustomPrice? customPrice;
  User? user;
  String? paymentStatus;
  String? orderTakingStatus;
  String? alreadyPaid;
  String? alreadyTaken;
  OrderPayment? orderPayment;
  OrderTaking? orderTaking;

  OrderDetailData(
      {this.id,
        this.createdAt,
        this.orderNumber,
        this.quantity,
        this.bonus,
        this.cashback,
        this.price,
        this.totalPrice,
        this.totalOrder,
        this.paymentStatus,
        this.orderTakingStatus,
        this.alreadyPaid,
        this.alreadyTaken,
        this.customPrice,
        this.user,
        this.orderPayment,
        this.orderTaking});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    orderNumber = json['order_number'];
    quantity = json['quantity'];
    bonus = json['bonus'];
    cashback = json['cashback'];
    price = json['price'];
    totalPrice = json['total_price'];
    totalOrder = json['total_order'];
    paymentStatus = json['payment_status'];
    orderTakingStatus = json['order_taking_status'];
    alreadyPaid = json['already_paid'];
    alreadyTaken = json['already_taken'];
    customPrice = json['custom_price'] != null
        ? CustomPrice.fromJson(json['custom_price'])
        : null;
    user = json['buyer'] != null ? User.fromJson(json['buyer']) : null;
    orderPayment = json['order_payment'] != null
        ? OrderPayment.fromJson(json['order_payment'])
        : null;
    orderTaking = json['order_taking'] != null
        ? OrderTaking.fromJson(json['order_taking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['order_number'] = orderNumber;
    data['quantity'] = quantity;
    data['bonus'] = bonus;
    data['cashback'] = cashback;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['total_order'] = totalOrder;
    if (customPrice != null) {
      data['custom_price'] = customPrice!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (orderPayment != null) {
      data['order_payment'] = orderPayment!.toJson();
    }
    if (orderTaking != null) {
      data['order_taking'] = orderTaking!.toJson();
    }
    return data;
  }
}

class CustomPrice {
  String? id;
  String? active;
  String? price;
  String? createdAt;
  String? updatedAt;

  CustomPrice(
      {this.id, this.active, this.price, this.createdAt, this.updatedAt});

  CustomPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['active'] = active;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? phoneNumber;
  String? role;

  User({this.name, this.email, this.phoneNumber, this.role});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    return data;
  }
}

class OrderPayment {
  String? id;
  String? alreadyPaid;
  String? notYetPaid;
  String? paymentStatus;

  OrderPayment(
      {this.id, this.alreadyPaid, this.notYetPaid, this.paymentStatus});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alreadyPaid = json['already_paid'];
    notYetPaid = json['not_yet_paid'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['already_paid'] = alreadyPaid;
    data['not_yet_paid'] = notYetPaid;
    data['payment_status'] = paymentStatus;
    return data;
  }
}

class OrderTaking {
  String? id;
  String? alreadyTaken;
  String? notYetTaken;
  String? orderTakingStatus;

  OrderTaking(
      {this.id, this.alreadyTaken, this.notYetTaken, this.orderTakingStatus});

  OrderTaking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alreadyTaken = json['already_taken'];
    notYetTaken = json['not_yet_taken'];
    orderTakingStatus = json['order_taking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['already_taken'] = alreadyTaken;
    data['not_yet_taken'] = notYetTaken;
    data['order_taking_status'] = orderTakingStatus;
    return data;
  }
}
