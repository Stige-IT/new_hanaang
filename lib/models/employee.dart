import 'position.dart';

class Employee {
  String? id;
  String? image;
  String? name;
  String? phoneNumber;
  Position? position;

  Employee({this.id, this.image, this.name, this.phoneNumber, this.position});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    position = json['position'] != null
        ? Position.fromJson(json['position'])
        : null;
  }
}


