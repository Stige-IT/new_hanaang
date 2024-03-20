class DetailHutang {
  String? id;
  String? createdAt;
  String? orderNumber;
  String? orderTakingStatus;
  String? paymentStatus;
  String? totalPayment;
  String? alreadyPaid;
  String? hutang;

  DetailHutang(
      {this.id,
        this.createdAt,
        this.orderNumber,
        this.orderTakingStatus,
        this.paymentStatus,
        this.totalPayment,
        this.alreadyPaid,
        this.hutang});

  DetailHutang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    orderNumber = json['order_number'];
    orderTakingStatus = json['order_taking_status'];
    paymentStatus = json['payment_status'];
    totalPayment = json['total_payment'];
    alreadyPaid = json['already_paid'];
    hutang = json['hutang'];
  }

}
