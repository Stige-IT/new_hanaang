import 'package:admin_hanaang/features/market/data/market_api.dart';
import 'package:admin_hanaang/features/market/provider/market_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/detail_market.dart';
import 'package:admin_hanaang/models/market.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketsNotifier =
    StateNotifierProvider<MarketsNotifier, BaseState<List<Market>>>((ref) {
  return MarketsNotifier(ref.watch(marketProvider));
});

final detailMarketNotifier =
    StateNotifierProvider<DetailMarketNotifier, BaseState<DetailMarket>>((ref) {
  return DetailMarketNotifier(ref.watch(marketProvider));
});
