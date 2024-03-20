import 'package:admin_hanaang/models/taking_order.dart';

class TakingOrderState {
  final List<TakingOrder>? data;
  final String? error;
  final bool isLoading;

  TakingOrderState({this.data, required this.isLoading, this.error});

  factory TakingOrderState.finished(List<TakingOrder> data) {
    return TakingOrderState(data: data, isLoading: false);
  }

  factory TakingOrderState.noState() {
    return TakingOrderState(isLoading: false);
  }

  factory TakingOrderState.loading() {
    return TakingOrderState(isLoading: true);
  }
  factory TakingOrderState.error(String error) {
    return TakingOrderState(isLoading: false, error: error);
  }
}
