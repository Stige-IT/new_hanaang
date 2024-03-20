import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/taking_order/data/taking_order_api.dart';
import 'package:admin_hanaang/features/taking_order/provider/payment_notifier.dart';
import 'package:admin_hanaang/features/taking_order/provider/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final takingOrderNotifier =
    StateNotifierProvider<TakingOrderNotifier, TakingOrderState>((ref) {
  return TakingOrderNotifier(ref.watch(takingOrderProvider));
});

final createTakingOrderNotifier =
    StateNotifierProvider<CreateTakingOrderNotifier, States>((ref) {
  return CreateTakingOrderNotifier(ref.watch(takingOrderProvider), ref);
});
