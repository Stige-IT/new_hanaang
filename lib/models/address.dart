class Address {
  final int id;
  final String name;

  Address({required this.id, required this.name});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
    );
  }
}
