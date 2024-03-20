
import 'package:admin_hanaang/features/taking_order/data/taking_order_api.dart';
import 'package:admin_hanaang/features/taking_order/provider/payment_provider.dart';
import 'package:admin_hanaang/features/taking_order/provider/payment_state.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../order/order.dart';
import '../../state.dart';

class TakingOrderNotifier extends StateNotifier<TakingOrderState> {
  TakingOrderNotifier(this.api) : super(TakingOrderState.noState());

  final TakingOrderApi api;

  Future getTakingOrder(String id, {bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = TakingOrderState.loading();
    }
    final result = await api.getTakingOrder(id);
    result.fold(
      (l) => state = TakingOrderState.error(l),
      (r) => state = TakingOrderState.finished(r),
    );
  }
}

class CreateTakingOrderNotifier extends StateNotifier<States> {
  CreateTakingOrderNotifier(this.api, this.ref) : super(States.noState());

  final TakingOrderApi api;
  final Ref ref;

  Future createTakingOrder(
    String id, {
    required String quantity,
    required String orderId,
  }) async {
    state = States.loading();
    try {
      final result = await api.createNewTakingOrder(id, quantity: quantity);
      state = result.fold(
        (error) => States.error(error),
        (success) {
          ref.read(orderNotifier.notifier).getOrders();
          ref.read(orderByIdNotifier.notifier).getOrdersById(orderId);
          ref.read(takingOrderNotifier.notifier).getTakingOrder(id);
          return States.noState();
        },
      );
      return result.isRight();
    } catch (e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}
