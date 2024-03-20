import 'package:admin_hanaang/models/pre_order.dart';

class PreOrderState {
  final PreOrder? data;
  final String? error;
  final bool isLoading;

  PreOrderState({this.data, required this.isLoading, this.error});

  factory PreOrderState.finished(PreOrder data) {
    return PreOrderState(data: data, isLoading: false);
  }

  factory PreOrderState.noState() {
    return PreOrderState(isLoading: false);
  }

  factory PreOrderState.loading() {
    return PreOrderState(isLoading: true);
  }
  factory PreOrderState.error(String error) {
    return PreOrderState(isLoading: false, error: error);
  }
}
