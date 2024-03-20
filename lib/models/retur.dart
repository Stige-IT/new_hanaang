import 'package:admin_hanaang/models/order.dart';

class Retur {
  String? id;
  String? date;
  String? returNumber;
  String? quantity;
  String? alreadyTaken;
  String? notYetTaken;
  String? detail;
  Status? status;
  List<ImageRetur>? image;
  String? messageRejected;
  User? user;
  OrderData? order;
  bool? isSelected;

  Retur({
    this.id,
    this.date,
    this.returNumber,
    this.quantity,
    this.alreadyTaken,
    this.notYetTaken,
    this.detail,
    this.status,
    this.image,
    this.messageRejected,
    this.user,
    this.order,
    this.isSelected,
  });

  Retur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    returNumber = json['retur_number'];
    quantity = json['quantity'];
    alreadyTaken = json['already_taken'];
    notYetTaken = json['not_yet_taken'];
    detail = json['detail'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    if (json['image'] != null) {
      image = <ImageRetur>[];
      json['image'].forEach((v) {
        image!.add(ImageRetur.fromJson(v));
      });
    }
    messageRejected = json['message_rejected'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    order = json['order'] != null ? OrderData.fromJson(json['order']) : null;
    isSelected= false;
  }
}

class Status {
  String? id;
  String? name;

  Status({this.id, this.name});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class ImageRetur {
  String? id;
  String? returId;
  String? image;
  String? createdAt;
  String? updatedAt;

  ImageRetur(
      {this.id, this.returId, this.image, this.createdAt, this.updatedAt});

  ImageRetur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    returId = json['retur_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;

  User({this.id, this.name, this.email, this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }
}
