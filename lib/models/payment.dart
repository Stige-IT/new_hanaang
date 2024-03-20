class Payment {
  String? id;
  String? paymentMethodId;
  String? proofOfPayment;
  String? nominal;
  String? createdAt;
  CreatedBy? createdBy;

  Payment(
      {this.id,
      this.paymentMethodId,
      this.proofOfPayment,
      this.nominal,
      this.createdAt,
      this.createdBy});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethodId = json['payment_method_id'];
    proofOfPayment = json['proof_of_payment'];
    nominal = json['nominal'];
    createdAt = json['created_at'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_method_id'] = paymentMethodId;
    data['proof_of_payment'] = proofOfPayment;
    data['nominal'] = nominal;
    data['created_at'] = createdAt;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    return data;
  }
}

class CreatedBy {
  String? name;
  String? email;

  CreatedBy({this.name, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
