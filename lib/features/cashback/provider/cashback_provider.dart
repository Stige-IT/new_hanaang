import 'package:admin_hanaang/features/cashback/data/cashback_api.dart';
import 'package:admin_hanaang/features/cashback/models/buyer_cashback.dart';
import 'package:admin_hanaang/features/cashback/provider/cashback_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeIdCashbackProvider =
    StateProvider.autoDispose<String?>((ref) => "Default");

final cashbackNotifier =
    StateNotifierProvider.autoDispose<CashbackNotifier, States>((ref) {
  return CashbackNotifier(ref.watch(cashbackProvider));
});

final buyerCashbackNotifier =
    NotifierProvider<CashbackBuyerNotifier, BaseState<List<BuyerCashback>>>(
        CashbackBuyerNotifier.new);

final createCashbackNotifier =
    StateNotifierProvider.autoDispose<CreateCashbackNotifier, States>((ref) {
  return CreateCashbackNotifier(ref.watch(cashbackProvider), ref);
});

final updateCashbackNotifier =
    StateNotifierProvider.autoDispose<UpdateCashbackNotifier, States>((ref) {
  return UpdateCashbackNotifier(ref.watch(cashbackProvider), ref);
});

final deleteCashbackNotifier =
    StateNotifierProvider.autoDispose<DeleteCashbackNotifier, States>((ref) {
  return DeleteCashbackNotifier(ref.watch(cashbackProvider), ref);
});

final checkCashbackNotifierProvider =
    StateNotifierProvider.autoDispose<CheckCashbackNotifier, States<int>>(
        (ref) {
  return CheckCashbackNotifier(ref.watch(cashbackProvider));
});
