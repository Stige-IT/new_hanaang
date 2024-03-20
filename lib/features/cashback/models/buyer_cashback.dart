class BuyerCashback {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  int? jumlahPesanan;
  int? totalCashback;

  BuyerCashback(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.jumlahPesanan,
      this.totalCashback});

  BuyerCashback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    jumlahPesanan = json['jumlah_pesanan'];
    totalCashback = json['total_cashback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['jumlah_pesanan'] = jumlahPesanan;
    data['total_cashback'] = totalCashback;
    return data;
  }
}
