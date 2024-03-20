import 'package:admin_hanaang/models/payment.dart';

class PaymentState {
  final List<Payment>? data;
  final String? error;
  final bool isLoading;

  PaymentState({this.data, required this.isLoading, this.error});

  factory PaymentState.finished(List<Payment> data) {
    return PaymentState(data: data, isLoading: false);
  }

  factory PaymentState.noState() {
    return PaymentState(isLoading: false);
  }

  factory PaymentState.loading() {
    return PaymentState(isLoading: true);
  }
  factory PaymentState.error(String error) {
    return PaymentState(isLoading: false, error: error);
  }
}
