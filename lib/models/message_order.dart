import 'package:admin_hanaang/models/history_income.dart';

class MessageOrder {
  String? id;
  String? beforeChange;
  String? afterChange;
  String? message;
  CreatedBy? createdBy;

  MessageOrder(
      {this.id,
      this.beforeChange,
      this.afterChange,
      this.message,
      this.createdBy});

  MessageOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beforeChange = json['before_change'];
    afterChange = json['after_change'];
    message = json['message'];
    createdBy = json['created_by'];
  }
}
