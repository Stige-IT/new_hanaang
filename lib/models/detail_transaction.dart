class DetailTransaction {
  String? id;
  String? orderId;
  PaymentMethodId? paymentMethodId;
  String? proofOfPayment;
  String? numberOfPayment;
  String? numberOfTaking;
  CreatedBy? createdBy;

  DetailTransaction(
      {this.id,
      this.orderId,
      this.paymentMethodId,
      this.proofOfPayment,
      this.numberOfPayment,
      this.numberOfTaking,
      this.createdBy});

  DetailTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    paymentMethodId = json['payment_method_id'] != null
        ? PaymentMethodId.fromJson(json['payment_method_id'])
        : null;
    proofOfPayment = json['proof_of_payment'];
    numberOfPayment = json['number_of_payment'];
    numberOfTaking = json['number_of_taking'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    if (paymentMethodId != null) {
      data['payment_method_id'] = paymentMethodId!.toJson();
    }
    data['proof_of_payment'] = proofOfPayment;
    data['number_of_payment'] = numberOfPayment;
    data['number_of_taking'] = numberOfTaking;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    return data;
  }
}

class PaymentMethodId {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  PaymentMethodId({this.id, this.name, this.createdAt, this.updatedAt});

  PaymentMethodId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CreatedBy {
  String? id;
  String? image;
  String? name;
  String? phoneNumber;
  String? email;
  String? emailVerifiedAt;
  String? addressId;
  String? roleId;
  String? suspend;
  String? createdAt;
  String? updatedAt;

  CreatedBy(
      {this.id,
      this.image,
      this.name,
      this.phoneNumber,
      this.email,
      this.emailVerifiedAt,
      this.addressId,
      this.roleId,
      this.suspend,
      this.createdAt,
      this.updatedAt});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    addressId = json['address_id'];
    roleId = json['role_id'];
    suspend = json['suspend'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['address_id'] = addressId;
    data['role_id'] = roleId;
    data['suspend'] = suspend;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
