class Hutang {
  String? id;
  String? name;
  String? email;
  String? numberPhone;
  int? totalOrder;

  Hutang({this.id, this.name, this.email, this.numberPhone, this.totalOrder});

  Hutang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    numberPhone = json['number_phone'];
    totalOrder = json['total_order'];
  }

}
