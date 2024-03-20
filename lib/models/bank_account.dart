class BankAccount {
  String? id;
  String? userId;
  String? primary;
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? ballance;
  String? createdAt;
  String? updatedAt;

  BankAccount({
    this.id,
    this.userId,
    this.primary,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.ballance,
    this.createdAt,
    this.updatedAt,
  });

  BankAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    primary = json['primary'];
    bankName = json['bank_name'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    ballance = json['ballance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
