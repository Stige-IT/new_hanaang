import '../../../models/cashback.dart';

class CashbackState {
  final List<Cashback>? data;
  final bool? isLoading;
  final String? error;

  CashbackState({this.data, this.isLoading, this.error});

  factory CashbackState.noState() => CashbackState(isLoading: false);
  factory CashbackState.loading() => CashbackState(isLoading: true);

  factory CashbackState.finished(List<Cashback> data) {
    return CashbackState(data: data, isLoading: false);
  }
}
