import 'package:admin_hanaang/features/fcm/fcm_api.dart';
import 'package:admin_hanaang/features/pre-order/data/pre_order_api.dart';
import 'package:admin_hanaang/features/pre-order/provider/pre_order_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/pre_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[state provider]
final isMoreThanTotalPriceProvider = StateProvider<bool>((ref) => false);

final preOrderNotifierProvider =
    StateNotifierProvider<PreOrderNotifier, States>((ref) {
  return PreOrderNotifier(ref.watch(preOrderProvider));
});
final openPreOrderNotifierProvider =
    StateNotifierProvider<OpenPreOrderNotifier, States<PreOrder>>((ref) {
  return OpenPreOrderNotifier(
    ref.watch(preOrderProvider),
    ref.watch(fcmNotificationProvider),
    ref,
  );
});
