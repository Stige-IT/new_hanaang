part of "../shift.dart";

class ShiftResponse{
  final bool? status;
  final String? message;

  ShiftResponse({this.status, this.message});

  factory ShiftResponse.fromJson(Map<String, dynamic> json) {
    return ShiftResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
