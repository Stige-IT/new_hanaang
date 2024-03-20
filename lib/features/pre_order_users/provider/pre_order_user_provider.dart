import 'package:admin_hanaang/features/pre_order_users/data/pre_order_user_api.dart';
import 'package:admin_hanaang/features/pre_order_users/provider/pre_order_user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/pre_order_user.dart';
import '../../state.dart';

final togglePaidProvider = StateProvider.autoDispose<bool>((ref) => false);
final dropdownMethodPainNotifier = StateProvider.autoDispose<String>(
        (ref) => "e103202b-f615-46ba-9e66-7efe8bc568b6");

final quantityNotifier = StateProvider.autoDispose<int>((ref) => 0);
final isShowProvider = StateProvider.autoDispose<bool>((ref) => false);


final preOrderUsersNotifierProvider =
    StateNotifierProvider<PreOrderUsersNotifier, States<List<PreOrderUser>>>(
        (ref) {
  return PreOrderUsersNotifier(ref.watch(preOrderUsersProvider));
});

final totalPreOrderNotifier = StateNotifierProvider<TotalPreOrderNotifier,States<int>>((ref) {
  return TotalPreOrderNotifier(ref.watch(preOrderUsersProvider));
});

final updatePreOrderUsersNotifier =
    StateNotifierProvider<UpdatePreOrderUsersNotifier, States>((ref) {
  return UpdatePreOrderUsersNotifier(ref.watch(preOrderUsersProvider), ref);
});

final resetPreOrderUsersNotifier =
    StateNotifierProvider<ResetPreOrderNotifier, States>((ref) {
  return ResetPreOrderNotifier(ref.watch(preOrderUsersProvider), ref);
});
