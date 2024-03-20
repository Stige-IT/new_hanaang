class OrderData {
  String? id;
  String? createdAt;
  String? orderNumber;
  int? totalPrice;
  int? totalOrder;
  String? paymentStatus;
  String? orderTakingStatus;

  OrderData(
      {this.id,
      this.createdAt,
      this.orderNumber,
      this.totalPrice,
      this.totalOrder,
      this.paymentStatus,
      this.orderTakingStatus});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    orderNumber = json['order_number'];
    totalPrice = json['total_price'];
    totalOrder = json['total_order'];
    paymentStatus = json['payment_status'];
    orderTakingStatus = json['order_taking_status'];
  }
}
