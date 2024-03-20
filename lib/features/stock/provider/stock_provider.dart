import 'package:admin_hanaang/features/stock/data/stock_api.dart';
import 'package:admin_hanaang/features/stock/provider/stock_notifier.dart';
import 'package:admin_hanaang/features/stock/provider/stock_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

final stockNotifier = StateNotifierProvider<StockNotifier, StockState>((ref) {
  return StockNotifier(ref.watch(stockProvider));
});

final totalStockNotifier =
    StateNotifierProvider<TotalStockNotifier, States<int>>((ref) {
  return TotalStockNotifier(ref.watch(stockProvider));
});

final soldStockNotifier =
    StateNotifierProvider<SoldStockNotifier, States<int>>((ref) {
  return SoldStockNotifier(ref.watch(stockProvider));
});

final returStockNotifier =
    StateNotifierProvider<ReturStockNotifier, States<int>>((ref) {
  return ReturStockNotifier(ref.watch(stockProvider));
});

final remainingStockNotifier =
    StateNotifierProvider<RemainingStockNotifier, States<int>>((ref) {
  return RemainingStockNotifier(ref.watch(stockProvider));
});
