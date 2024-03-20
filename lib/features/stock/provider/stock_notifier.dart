import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/stock/data/stock_api.dart';
import 'package:admin_hanaang/features/stock/provider/stock_state.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockNotifier extends StateNotifier<StockState> {
  StockNotifier(this.api) : super(StockState.noState());

  final StockApi api;

  Future getStock() async {
    state = StockState.loading();
    final total = await api.getStock(type: 'total_stock');
    final sold = await api.getStock(type: 'sold_stock');
    final retur = await api.getStock(type: 'retur_stock');
    final remaining = await api.getStock(type: 'remaining_stock');
    total.fold(
        (error) => state = StockState.error(error),
        (total) => sold.fold(
              (error) => state = StockState.error(error),
              (sold) => retur.fold(
                (error) => state = StockState.error(error),
                (retur) => remaining.fold(
                  (error) => state = StockState.error(error),
                  (remaining) => state = StockState.finished(
                    total: total,
                    sold: sold,
                    remaining: remaining,
                    retur: retur,
                  ),
                ),
              ),
            ));
  }
}

class TotalStockNotifier extends StateNotifier<States<int>> {
  final StockApi _stockApi;
  TotalStockNotifier(this._stockApi) : super(States.noState());

  Future<void> getStock() async {
    try {
      final result = await _stockApi.getStock(type: 'total_stock');
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class SoldStockNotifier extends StateNotifier<States<int>> {
  final StockApi _stockApi;
  SoldStockNotifier(this._stockApi) : super(States.noState());

  Future<void> getStock() async {
    try {
      final result = await _stockApi.getStock(type: 'sold_stock');
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class ReturStockNotifier extends StateNotifier<States<int>> {
  final StockApi _stockApi;
  ReturStockNotifier(this._stockApi) : super(States.noState());

  Future<void> getStock() async {
    try {
      final result = await _stockApi.getStock(type: 'retur_stock');
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class RemainingStockNotifier extends StateNotifier<States<int>> {
  final StockApi _stockApi;
  RemainingStockNotifier(this._stockApi) : super(States.noState());

  Future<void> getStock() async {
    try {
      final result = await _stockApi.getStock(type: 'remaining_stock');
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}
