import 'package:admin_hanaang/features/bonus/data/bonus_api.dart';
import 'package:admin_hanaang/features/bonus/provider/bonus_notifier.dart';
import 'package:admin_hanaang/models/bonus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

final typeIdBonusProvider =
    StateProvider.autoDispose<String>((ref) => "Default");

final bonusNotifierProvider =
    StateNotifierProvider.autoDispose<BonusNotifier, States<List<Bonus>>>((ref) {
  return BonusNotifier(ref.watch(bonusProvider));
});

final createBonusNotifier =
    StateNotifierProvider<CreateBonusNotifier, States>((ref) {
  return CreateBonusNotifier(ref.watch(bonusProvider), ref);
});

final updateBonusNotifier =
    StateNotifierProvider<UpdateBonusNotifier, States>((ref) {
  return UpdateBonusNotifier(ref.watch(bonusProvider), ref);
});

final deleteBonusNotifier =
    StateNotifierProvider<DeleteBonusNotifier, States>((ref) {
  return DeleteBonusNotifier(ref.watch(bonusProvider), ref);
});

final checkBonusNotifierProvider =
    StateNotifierProvider.autoDispose<CheckBonusNotifier, int>((ref) {
  return CheckBonusNotifier(ref.watch(bonusProvider));
});
